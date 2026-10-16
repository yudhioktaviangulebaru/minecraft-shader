// Shared constants and helper functions (no uniforms here).
#ifndef LIB_COMMON
#define LIB_COMMON

const float PI          = 3.14159265;
const float GAMMA       = 2.2;     // approximate sRGB transfer exponent
const float ALPHA_CUTOFF = 0.1;    // vanilla cutout threshold

vec3 toLinear(vec3 c) { return pow(max(c, 0.0), vec3(GAMMA)); }
vec3 toSRGB(vec3 c)   { return pow(max(c, 0.0), vec3(1.0 / GAMMA)); }

float luminance(vec3 c) { return dot(c, vec3(0.2126, 0.7152, 0.0722)); }

float saturate(float x) { return clamp(x, 0.0, 1.0); }

// Octahedral normal encoding into [0,1]^2
vec2 encodeNormal(vec3 n) {
    n /= abs(n.x) + abs(n.y) + abs(n.z);
    vec2 e = n.z >= 0.0 ? n.xy : (1.0 - abs(n.yx)) * vec2(n.x >= 0.0 ? 1.0 : -1.0, n.y >= 0.0 ? 1.0 : -1.0);
    return e * 0.5 + 0.5;
}

vec3 decodeNormal(vec2 e) {
    e = e * 2.0 - 1.0;
    vec3 n = vec3(e, 1.0 - abs(e.x) - abs(e.y));
    float t = max(-n.z, 0.0);
    n.xy -= t * vec2(n.x >= 0.0 ? 1.0 : -1.0, n.y >= 0.0 ? 1.0 : -1.0);
    return normalize(n);
}

// Screen (uv + depth in [0,1]) <-> view space
vec3 screenToView(vec2 uv, float depth, mat4 projInv) {
    vec4 v = projInv * vec4(vec3(uv, depth) * 2.0 - 1.0, 1.0);
    return v.xyz / v.w;
}

vec3 viewToScreen(vec3 viewPos, mat4 proj) {
    vec4 c = proj * vec4(viewPos, 1.0);
    return (c.xyz / c.w) * 0.5 + 0.5;
}

#endif
