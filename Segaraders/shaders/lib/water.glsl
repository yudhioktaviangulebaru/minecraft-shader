// Water surface model: procedural waves, normals, caustics, optics.
// Requires: settings.glsl, common.glsl, noise.glsl
#ifndef LIB_WATER
#define LIB_WATER

const float WATER_BLOCK_ID      = 10008.0; // block.properties id for water

// ---- Wave spectrum ----
const float WAVE_BASE_FREQ      = 0.35;    // radians per block of the longest wave (~18 blocks)
const float WAVE_FREQ_MUL       = 1.75;    // frequency growth per octave
const float WAVE_AMP_MUL        = 0.55;    // amplitude decay per octave
const float WAVE_PHASE_SPEED    = 1.2;     // temporal speed; scaled by sqrt(freq) (deep-water dispersion)
const float WAVE_DIR_ROTATION   = 2.39996; // golden angle in radians, decorrelates octave directions
const float WAVE_DRAG           = 0.25;    // how much big waves push small ones along (blocks)
const int   WAVE_VERTEX_OCTAVES = 3;       // octaves used for geometry displacement

// ---- Surface normal ----
const float NORMAL_SAMPLE_DIST  = 0.04;    // finite-difference step (blocks)
const float NORMAL_HEIGHT       = 0.35;    // height scale used to derive normals
const float NORMAL_FADE_DIST    = 48.0;    // blocks; normals flatten with distance to avoid aliasing
const float RIPPLE_FREQ         = 4.0;     // fine ripple noise frequency (1/blocks)
const float RIPPLE_AMOUNT       = 0.04;    // ripple contribution to height
const float RIPPLE_SPEED        = 0.6;

// ---- Optics ----
const float WATER_IOR           = 1.333;
const float WATER_F0            = 0.02;    // reflectance at normal incidence
const float WATER_ABSORPTION    = 0.35;    // absorption per block for a fully absorbed channel
const float WATER_TURBIDITY     = 0.02;    // minimum absorption per block
const float WATER_SCATTER       = 0.5;     // in-scattering brightness
const vec3  WATER_DEFAULT_TINT  = vec3(0.25, 0.46, 0.89); // sRGB, used when biome tint is off

// Sum of sharp-crested directional waves, returns height in [0,1]
float waterWaves(vec2 p, float time, int octaves) {
    float height = 0.0;
    float weight = 0.0;
    float amp    = 1.0;
    float freq   = WAVE_BASE_FREQ;
    float angle  = 0.6;
    for (int i = 0; i < octaves; i++) {
        vec2 dir   = vec2(cos(angle), sin(angle));
        float x    = dot(dir, p) * freq + time * WAVE_PHASE_SPEED * sqrt(freq);
        float wave = exp(sin(x) - 1.0);           // sharp crests, wide troughs
        p         -= dir * wave * cos(x) * amp * WAVE_DRAG;
        height    += wave * amp;
        weight    += amp;
        amp       *= WAVE_AMP_MUL;
        freq      *= WAVE_FREQ_MUL;
        angle     += WAVE_DIR_ROTATION;
    }
    return height / weight;
}

float waterHeightDetail(vec2 p, float time) {
    float ripple = valueNoise(p * RIPPLE_FREQ + vec2(time * RIPPLE_SPEED, -time * RIPPLE_SPEED * 0.7));
    return waterWaves(p, time, WATER_WAVE_OCTAVES) + ripple * RIPPLE_AMOUNT;
}

// World-space surface normal (y-up) at world xz
vec3 waterNormal(vec2 p, float time, float viewDist) {
    float h0 = waterHeightDetail(p, time);
    float hx = waterHeightDetail(p + vec2(NORMAL_SAMPLE_DIST, 0.0), time);
    float hz = waterHeightDetail(p + vec2(0.0, NORMAL_SAMPLE_DIST), time);
    float strength = NORMAL_HEIGHT * WATER_NORMAL_STRENGTH / (1.0 + viewDist / NORMAL_FADE_DIST);
    vec2 grad = vec2(hx - h0, hz - h0) / NORMAL_SAMPLE_DIST * strength;
    return normalize(vec3(-grad.x, 1.0, -grad.y));
}

// Bright caustic network in [0,1]
const float CAUSTIC_SCALE_A = 0.9;
const float CAUSTIC_SCALE_B = 1.4;
const float CAUSTIC_LINE_WIDTH = 0.22;

float waterCaustics(vec2 p, float time) {
    float a = cellEdge(p * CAUSTIC_SCALE_A + vec2(0.05, 0.03) * time, time * 1.1);
    float b = cellEdge(p * CAUSTIC_SCALE_B - vec2(0.03, 0.05) * time, time * 0.9 + 1.7);
    float lines = (1.0 - smoothstep(0.0, CAUSTIC_LINE_WIDTH, a)) + (1.0 - smoothstep(0.0, CAUSTIC_LINE_WIDTH, b));
    return lines * lines * 0.25;
}

// Per-block absorption coefficient from a (sRGB) water tint:
// channels the tint lacks are absorbed fastest, which reproduces natural water color.
vec3 waterAbsorption(vec3 tintSRGB) {
    return ((1.0 - tintSRGB) * WATER_ABSORPTION + WATER_TURBIDITY) / WATER_CLARITY;
}

float fresnelSchlick(float cosTheta, float f0) {
    return f0 + (1.0 - f0) * pow(1.0 - saturate(cosTheta), 5.0);
}

#endif
