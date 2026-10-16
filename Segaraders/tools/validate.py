#!/usr/bin/env python3
"""Segaraders shader pack validator.

- Inlines #include "/lib/..." manually (with line mapping back to source files)
- Injects OptiFine/Iris predefined macro stubs
- Compiles every .vsh/.fsh with glslangValidator, once per menu profile
  (so #ifdef paths of every profile are checked)
- Checks RENDERTARGETS count vs fragment outputs
- Checks vertex outputs vs fragment inputs (varyings) per program
- Checks every option in lib/settings.glsl is on a menu screen and has lang entries
"""
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "shaders"))
SETTINGS = os.path.join(ROOT, "lib", "settings.glsl")
PROPS = os.path.join(ROOT, "shaders.properties")
LANGS = ["en_us.lang", "id_id.lang"]
PROGRAM_DIRS = ["", "world0", "world-1", "world1"]

# OptiFine / Iris predefined macros (stub values)
STUB_MACROS = {
    "MC_VERSION": "12001",
    "MC_GL_VERSION": "330",
    "MC_GLSL_VERSION": "330",
    "MC_OS_LINUX": "",
    "MC_RENDER_QUALITY": "1.0",
    "MC_SHADOW_QUALITY": "1.0",
    "MC_HAND_DEPTH": "0.125",
}

errors = []
warnings = []


def err(msg):
    errors.append(msg)


def warn(msg):
    warnings.append(msg)


# ---------------------------------------------------------------- include
INCLUDE_RE = re.compile(r'^\s*#include\s+"([^"]+)"')


def inline(path, stack=()):
    """Return list of (text, srcfile, srcline)."""
    if path in stack:
        raise RuntimeError("include cycle: " + " -> ".join(stack + (path,)))
    out = []
    with open(path, encoding="utf-8") as f:
        for i, line in enumerate(f.read().split("\n"), 1):
            m = INCLUDE_RE.match(line)
            if m:
                inc = m.group(1)
                inc_path = os.path.join(ROOT, inc.lstrip("/")) if inc.startswith("/") \
                    else os.path.join(os.path.dirname(path), inc)
                if not os.path.isfile(inc_path):
                    err(f"{rel(path)}:{i}: include not found: {inc}")
                    continue
                out.extend(inline(inc_path, stack + (path,)))
            else:
                out.append((line, path, i))
    return out


def rel(p):
    return os.path.relpath(p, os.path.dirname(ROOT))


# ---------------------------------------------------------------- options
OPT_RE = re.compile(r'^\s*(//)?\s*#define\s+([A-Z][A-Z0-9_]*)\b\s*([^\s/]+)?\s*(//.*)?$')


def parse_options():
    opts = {}
    with open(SETTINGS, encoding="utf-8") as f:
        for i, line in enumerate(f, 1):
            m = OPT_RE.match(line)
            if not m:
                continue
            commented, name, value, comment = m.groups()
            if value is None:
                opts[name] = {"type": "bool", "default": not commented, "line": i}
            else:
                allowed = re.search(r"\[(.*?)\]", comment or "")
                opts[name] = {"type": "value", "default": value, "line": i,
                              "values": allowed.group(1).split() if allowed else []}
    return opts


def parse_props():
    props = {}
    with open(PROPS, encoding="utf-8") as f:
        text = f.read().replace("\\\n", " ")
    for line in text.split("\n"):
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        props[k.strip()] = v.strip()
    return props


def parse_lang(path):
    keys = set()
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                keys.add(line.split("=", 1)[0].strip())
    return keys


def parse_profiles(props, opts):
    profiles = {}
    for k, v in props.items():
        if not k.startswith("profile."):
            continue
        name = k[len("profile."):]
        settings = {}
        for tok in v.split():
            if tok.startswith("profile."):
                settings.update(profiles.get(tok[len("profile."):], {}))
                continue
            if ":" in tok or "=" in tok:
                o, val = re.split("[:=]", tok, maxsplit=1)
                if o not in opts:
                    err(f"shaders.properties: profile {name} sets unknown option {o}")
                elif opts[o]["type"] != "value":
                    err(f"shaders.properties: profile {name} gives a value to boolean {o}")
                elif opts[o]["values"] and val not in opts[o]["values"]:
                    err(f"shaders.properties: profile {name}: {o}={val} not in [{' '.join(opts[o]['values'])}]")
                settings[o] = val
            else:
                on = not tok.startswith("!")
                o = tok.lstrip("!")
                if o not in opts:
                    err(f"shaders.properties: profile {name} toggles unknown option {o}")
                elif opts[o]["type"] != "bool":
                    err(f"shaders.properties: profile {name} toggles value option {o} as boolean")
                settings[o] = on
        profiles[name] = settings
    return profiles


def check_menu(opts, props):
    screen_items = set()
    screens = set()
    for k, v in props.items():
        if k == "screen" or k.startswith("screen."):
            for tok in v.split():
                if tok.startswith("[") and tok.endswith("]"):
                    screens.add(tok[1:-1])
                elif tok not in ("<empty>", "<profile>", "*"):
                    screen_items.add(tok)
    for s in screens:
        if f"screen.{s}" not in props:
            err(f"shaders.properties: screen [{s}] is referenced but screen.{s} is not defined")
    for item in screen_items:
        if item not in opts:
            err(f"shaders.properties: screen lists unknown option {item}")
    sliders = set(props.get("sliders", "").split())
    for s in sliders:
        if s not in opts:
            err(f"shaders.properties: sliders lists unknown option {s}")
    langs = {l: parse_lang(os.path.join(ROOT, "lang", l)) for l in LANGS}
    for name, o in opts.items():
        if name not in screen_items:
            err(f"lib/settings.glsl:{o['line']}: option {name} is not on any menu screen")
        for l, keys in langs.items():
            if f"option.{name}" not in keys:
                err(f"lang/{l}: missing option.{name}")
    for l, keys in langs.items():
        for s in screens:
            if f"screen.{s}" not in keys:
                err(f"lang/{l}: missing screen.{s}")


def apply_profile(lines, opts, settings):
    """Rewrite option #defines (only those coming from settings.glsl)."""
    out = []
    for text, src, ln in lines:
        if src == SETTINGS:
            m = OPT_RE.match(text)
            if m and m.group(2) in settings:
                name = m.group(2)
                val = settings[name]
                if opts[name]["type"] == "bool":
                    text = f"#define {name}" if val else f"// #define {name}"
                else:
                    text = f"#define {name} {val}"
        out.append((text, src, ln))
    return out


# ---------------------------------------------------------------- compile
GLSLANG = "glslangValidator"
ERR_LINE_RE = re.compile(r"^(ERROR|WARNING): 0:(\d+): (.*)$")


def assemble(lines):
    """Put stub macros right after #version. Returns (source, mapping)."""
    src_lines, mapping = [], []
    for idx, (text, src, ln) in enumerate(lines):
        src_lines.append(text)
        mapping.append((src, ln))
        if text.strip().startswith("#version"):
            for k, v in STUB_MACROS.items():
                src_lines.append(f"#define {k} {v}".rstrip())
                mapping.append(("<stub>", 0))
    return "\n".join(src_lines) + "\n", mapping


def run_glslang(source, stage, args=()):
    with tempfile.NamedTemporaryFile("w", suffix="." + stage, delete=False) as f:
        f.write(source)
        tmp = f.name
    try:
        p = subprocess.run([GLSLANG, *args, "-S", stage, tmp], capture_output=True, text=True)
        return p.returncode, p.stdout + p.stderr
    finally:
        os.unlink(tmp)


def compile_program(path, lines, profile_name):
    stage = "vert" if path.endswith(".vsh") else "frag"
    source, mapping = assemble(lines)
    code, output = run_glslang(source, stage)
    ok = code == 0
    for line in output.splitlines():
        m = ERR_LINE_RE.match(line.strip())
        if m:
            kind, ln, msg = m.groups()
            ln = int(ln)
            src, sln = mapping[ln - 1] if 0 < ln <= len(mapping) else ("?", ln)
            loc = f"{rel(src)}:{sln}" if src != "<stub>" else "<stub>"
            text = f"[{profile_name}] {rel(path)} -> {loc}: {msg}"
            (err if kind == "ERROR" else warn)(text)
            ok = False if kind == "ERROR" else ok
    if code != 0 and ok:
        err(f"[{profile_name}] {rel(path)}: glslang failed:\n{output}")
        ok = False
    return ok, source


def preprocess(source, stage):
    code, output = run_glslang(source, stage, ("-E",))
    return output if code == 0 else ""


# ---------------------------------------------------------------- checks
OUT_LOC_RE = re.compile(r"layout\s*\(\s*location\s*=\s*(\d+)\s*\)\s*out\s+\w+\s+(\w+)")
TARGETS_RE = re.compile(r"/\*\s*(RENDERTARGETS|DRAWBUFFERS)\s*:\s*([0-9,\s]+?)\s*\*/")
VARYING_RE = re.compile(
    r"^\s*(?:(?:flat|smooth|noperspective|centroid)\s+)*(in|out)\s+(\w+)\s+(\w+)\s*;", re.M)


def check_targets(path, raw_text, pre):
    targets = TARGETS_RE.findall(raw_text)
    if not targets:
        err(f"{rel(path)}: no RENDERTARGETS/DRAWBUFFERS declaration")
        return
    kind, val = targets[-1]
    n = len([t for t in val.split(",") if t.strip()]) if kind == "RENDERTARGETS" else len(val.strip())
    locs = sorted({int(l) for l, _ in OUT_LOC_RE.findall(pre)})
    uses_fragdata = "gl_FragData" in pre or "gl_FragColor" in pre
    if uses_fragdata and locs:
        err(f"{rel(path)}: mixes gl_FragData/gl_FragColor with layout outputs")
    if locs:
        if locs != list(range(len(locs))):
            err(f"{rel(path)}: output locations {locs} are not contiguous from 0")
        if len(locs) != n:
            err(f"{rel(path)}: {kind} declares {n} target(s) but shader writes {len(locs)} output(s)")


def varyings(pre, direction):
    res = {}
    for d, typ, name in VARYING_RE.findall(pre):
        if d == direction:
            res[name] = typ
    return res


def check_varyings(vsh_path, vsh_pre, fsh_path, fsh_pre, profile_name):
    outs = varyings(vsh_pre, "out")
    ins = varyings(fsh_pre, "in")
    for name, typ in ins.items():
        if name not in outs:
            err(f"[{profile_name}] {rel(fsh_path)}: input '{name}' has no matching output in {os.path.basename(vsh_path)}")
        elif outs[name] != typ:
            err(f"[{profile_name}] {rel(fsh_path)}: input '{name}' is {typ} but {os.path.basename(vsh_path)} outputs {outs[name]}")
    for name in outs:
        if name not in ins:
            warn(f"[{profile_name}] {rel(vsh_path)}: output '{name}' is unused by the fragment shader")


# ---------------------------------------------------------------- main
def main():
    if subprocess.run(["which", GLSLANG], capture_output=True).returncode != 0:
        print("glslangValidator not found (sudo apt install glslang-tools)")
        return 2

    opts = parse_options()
    props = parse_props()
    profiles = parse_profiles(props, opts)
    check_menu(opts, props)
    variants = {"default": {}}
    variants.update(profiles)
    # Stress variants so every #ifdef / #if branch gets compiled at least once
    variants["all-flipped-min"] = {n: (not o["default"]) if o["type"] == "bool" else o["values"][0]
                                   for n, o in opts.items() if o["type"] == "bool" or o["values"]}
    variants["max"] = {n: o["values"][-1] for n, o in opts.items() if o["type"] == "value" and o["values"]}

    programs = []
    for d in PROGRAM_DIRS:
        base = os.path.join(ROOT, d)
        if not os.path.isdir(base):
            continue
        for f in sorted(os.listdir(base)):
            if f.endswith((".vsh", ".fsh")):
                programs.append(os.path.join(base, f))

    compiled = 0
    seen = set()
    for vname, settings in variants.items():
        pre_cache = {}
        for path in programs:
            lines = apply_profile(inline(path), opts, settings)
            source, _ = assemble(lines)
            key = (path, source)
            if key in seen:
                pre_cache[path] = pre_cache.get(path) or preprocess(source, "vert" if path.endswith(".vsh") else "frag")
                continue
            seen.add(key)
            ok, source = compile_program(path, lines, vname)
            compiled += 1
            if ok:
                stage = "vert" if path.endswith(".vsh") else "frag"
                pre_cache[path] = preprocess(source, stage)
                if stage == "frag":
                    with open(path, encoding="utf-8") as f:
                        check_targets(path, f.read(), pre_cache[path])
        for path in programs:
            if path.endswith(".fsh"):
                vsh = path[:-4] + ".vsh"
                if not os.path.exists(vsh):
                    err(f"{rel(path)}: missing matching {os.path.basename(vsh)}")
                elif pre_cache.get(path) and pre_cache.get(vsh):
                    check_varyings(vsh, pre_cache[vsh], path, pre_cache[path], vname)

    for w in sorted(set(warnings)):
        print("WARN  " + w)
    for e in sorted(set(errors)):
        print("ERROR " + e)
    print(f"\n{len(programs)} program files x {len(variants)} variants "
          f"({compiled} unique compiles), {len(set(errors))} error(s), {len(set(warnings))} warning(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
