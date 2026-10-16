#version 330 compatibility
// composite: water shading (refraction, absorption, reflections, specular,
// caustics, foam), underwater fog and border fog.

#include "/lib/settings.glsl"
#include "/lib/common.glsl"
#include "/lib/noise.glsl"
#include "/lib/sky.glsl"
#include "/lib/water.glsl"
#include "/lib/ssr.glsl"

/*
const int colortex0Format = RGBA16F;
const int colortex1Format = RGBA16;
const int colortex2Format = RGBA8;
*/
const vec4 colortex1ClearColor = vec4(0.0, 0.0, 0.0, 0.0);
const vec4 colortex2ClearColor = vec4(0.0, 0.0, 0.0, 0.0);

in vec2 texcoord;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform vec3 sunPosition;
uniform vec3 shadowLightPosition;
uniform vec3 skyColor;
uniform vec3 fogColor;
uniform float far;
uniform float frameTimeCounter;
uniform float rainStrength;
uniform int isEyeInWater;
uniform ivec2 eyeBrightnessSmooth;

// ---- Lighting environment ----
const vec3  SUN_NOON_COLOR      = vec3(1.00, 0.95, 0.85);
const vec3  SUN_LOW_COLOR       = vec3(1.00, 0.45, 0.15);
const vec3  MOON_COLOR          = vec3(0.10, 0.12, 0.18);
const float SUN_SPEC_POWER      = 1200.0;  // Blinn-Phong exponent of the sun glint
const float AMBIENT_SKY_WEIGHT  = 0.6;
const float AMBIENT_SUN_WEIGHT  = 0.15;
const float EYE_BRIGHTNESS_MAX  = 240.0;   // eyeBrightness range

// ---- Water surface ----
const float REFRACTION_SCALE    = 0.12;    // screen uv per unit of normal tilt
const float REFRACTION_DIST_FALLOFF = 0.05; // 1/blocks
const float REFRACTION_DEPTH_RAMP   = 0.5;  // 1/blocks; shallow water distorts less
const float FOAM_WIDTH          = 0.6;     // blocks of water depth showing foam
const float FOAM_NOISE_FREQ     = 2.5;     // 1/blocks
const float FOAM_OPACITY        = 0.8;
const vec3  FOAM_COLOR          = vec3(0.9);
const float CAUSTIC_DEPTH_FADE  = 0.15;    // 1/blocks
const float CAUSTIC_DIST_FADE   = 0.04;    // 1/blocks (underwater view)
const float SKY_REFLECT_MIN_LIGHT = 0.2;   // sky light below this reflects no sky
const float SKY_REFLECT_FULL_LIGHT = 0.9;

// ---- Other media ----
const vec3  LAVA_FOG_COLOR      = vec3(1.0, 0.25, 0.02);
const float LAVA_FOG_DENSITY    = 1.5;     // 1/blocks
const vec3  SNOW_FOG_COLOR      = vec3(0.75, 0.82, 0.9);
const float SNOW_FOG_DENSITY    = 1.0;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 outColor0;

struct Light {
    vec3 sun;      // direct light color (sun or moon)
    vec3 ambient;  // sky ambient
    vec3 dirView;  // direction to the current light source (view space)
    vec3 dirWorld;
    vec3 sunWorld; // sun direction (world), used by the sky model
};

Light getLight() {
    Light l;
    l.sunWorld = normalize(mat3(gbufferModelViewInverse) * sunPosition);
    l.dirView  = normalize(shadowLightPosition);
    l.dirWorld = mat3(gbufferModelViewInverse) * l.dirView;
    float day  = smoothstep(-0.1, 0.15, l.sunWorld.y);
    vec3 sunCol = mix(SUN_LOW_COLOR, SUN_NOON_COLOR, smoothstep(0.0, 0.4, l.sunWorld.y));
    l.sun      = mix(MOON_COLOR, sunCol, day) * (1.0 - rainStrength * 0.8);
    l.ambient  = toLinear(skyColor);
    return l;
}

vec3 skyAt(vec3 worldDir, Light l) {
    return computeSky(worldDir, l.sunWorld, toLinear(skyColor), toLinear(fogColor));
}

vec3 waterScatter(vec3 tintSRGB, Light l, float skyLight) {
    vec3 light = l.ambient * AMBIENT_SKY_WEIGHT + l.sun * AMBIENT_SUN_WEIGHT;
    return toLinear(tintSRGB) * light * WATER_SCATTER * skyLight * skyLight;
}

vec3 viewToWorld(vec3 viewPos) {
    return mat3(gbufferModelViewInverse) * viewPos + gbufferModelViewInverse[3].xyz + cameraPosition;
}

// Interleaved gradient noise for ray jitter
float dither() {
    return fract(52.9829189 * fract(dot(gl_FragCoord.xy, vec2(0.06711056, 0.00583715))));
}

vec3 shadeWater(vec3 surfPos, vec3 viewDir, vec4 data, vec3 tint, Light l) {
    float underwater = float(isEyeInWater == 1);
    vec3 normal  = faceforward(decodeNormal(data.xy), viewDir, decodeNormal(data.xy));
    vec3 upView  = gbufferModelView[1].xyz;
    vec3 flatN   = faceforward(upView, viewDir, upView);
    float skyLight = data.z;
    float time   = frameTimeCounter * WATER_WAVE_SPEED;

    // Water depth along the unrefracted view ray (for foam and refraction ramp)
    vec3 opaquePos0  = screenToView(texcoord, texture(depthtex1, texcoord).r, gbufferProjectionInverse);
    float thickness0 = distance(opaquePos0, surfPos);
    vec3 surfWorld   = viewToWorld(surfPos);

    // ---- Refraction ----
    vec2 refrUV = texcoord;
#ifdef WATER_REFRACTION
    vec2 offset = (normal - flatN).xy * REFRACTION_SCALE * WATER_REFRACTION_STRENGTH;
    offset *= saturate(thickness0 * REFRACTION_DEPTH_RAMP) / (1.0 + length(surfPos) * REFRACTION_DIST_FALLOFF);
    vec2 candidate = clamp(texcoord + offset, 0.001, 0.999);
    vec3 candPos = screenToView(candidate, texture(depthtex1, candidate).r, gbufferProjectionInverse);
    // Reject samples of geometry in front of the water surface
    refrUV = mix(texcoord, candidate, step(candPos.z, surfPos.z));
#endif
    vec3 behind     = texture(colortex0, refrUV).rgb;
    float opaqueDepth = texture(depthtex1, refrUV).r;
    vec3 opaquePos  = screenToView(refrUV, opaqueDepth, gbufferProjectionInverse);
    float thickness = mix(distance(opaquePos, surfPos), far, step(0.99999, opaqueDepth));

    // ---- Caustics on the floor ----
#ifdef WATER_CAUSTICS
    vec3 floorWorld = viewToWorld(opaquePos);
    // project the surface pattern along the light direction onto the floor
    float depthBelow = max(surfWorld.y - floorWorld.y, 0.0);
    vec2 causticPos  = floorWorld.xz - l.dirWorld.xz / max(l.dirWorld.y, 0.2) * depthBelow;
    float caustic    = waterCaustics(causticPos, time);
    float causticAmt = WATER_CAUSTICS_STRENGTH * skyLight * exp(-thickness * CAUSTIC_DEPTH_FADE)
                     * luminance(l.sun) * (1.0 - underwater);
    behind *= 1.0 + caustic * causticAmt;
#endif

    // ---- Absorption + in-scattering (only when looking down into water) ----
    vec3 scatter = waterScatter(tint, l, skyLight);
    vec3 transmittance = exp(-waterAbsorption(tint) * thickness);
    vec3 below = mix(behind, behind * transmittance + scatter * (1.0 - transmittance), 1.0 - underwater);

    // ---- Reflection ----
    vec3 reflDir   = reflect(viewDir, normal);
    vec3 reflWorld = mat3(gbufferModelViewInverse) * reflDir;
    reflWorld.y    = abs(reflWorld.y);           // wave-tilted normals must not reflect the ground
    float skyVisible = smoothstep(SKY_REFLECT_MIN_LIGHT, SKY_REFLECT_FULL_LIGHT, skyLight);
    vec3 reflection = skyAt(normalize(reflWorld), l) * skyVisible;
    float reflectWeight = 1.0;
#if WATER_REFLECTIONS == 2
    vec4 ssr = traceSSR(surfPos, reflDir, dither(), depthtex1, colortex0, gbufferProjection, gbufferProjectionInverse);
    reflection = mix(reflection, ssr.rgb, ssr.a);
#elif WATER_REFLECTIONS == 0
    reflectWeight = 0.0;
#endif

    float cosTheta = dot(-viewDir, normal);
    float fresnel  = fresnelSchlick(cosTheta, WATER_F0) * reflectWeight;

    // From below: total internal reflection outside Snell's window
    vec3 refracted = refract(viewDir, normal, WATER_IOR);
    float tir = 1.0 - step(1e-4, dot(refracted, refracted));
    vec3 fromBelow = mix(behind, scatter, max(tir, fresnel));

    vec3 fromAbove = mix(below, reflection, fresnel);

    // ---- Sun / moon glint ----
    vec3 halfVec  = normalize(l.dirView - viewDir);
    float nDotL   = saturate(dot(normal, l.dirView));
    float spec    = pow(saturate(dot(normal, halfVec)), SUN_SPEC_POWER) * (SUN_SPEC_POWER + 8.0) / (8.0 * PI);
    vec3 specular = l.sun * spec * nDotL * fresnelSchlick(dot(halfVec, -viewDir), WATER_F0)
                  * WATER_SUN_SPECULAR * skyVisible * (1.0 - rainStrength);
    fromAbove += specular;

    // ---- Shore foam ----
#ifdef WATER_FOAM
    float foamNoise = valueNoise(surfWorld.xz * FOAM_NOISE_FREQ + time * 0.3)
                    * valueNoise(surfWorld.xz * FOAM_NOISE_FREQ * 2.3 - time * 0.2);
    float foamEdge  = 1.0 - smoothstep(0.0, FOAM_WIDTH, thickness0);
    float foam      = saturate(foamEdge * 1.5 - (1.0 - foamNoise) * 0.9) * FOAM_OPACITY;
    vec3 foamLight  = l.ambient + l.sun * nDotL;
    fromAbove = mix(fromAbove, FOAM_COLOR * foamLight * skyLight, foam);
#endif

    return mix(fromAbove, fromBelow, underwater);
}

void main() {
    vec3 color   = texture(colortex0, texcoord).rgb;
    float depth0 = texture(depthtex0, texcoord).r;
    vec4 waterData = texture(colortex1, texcoord);
    vec4 waterTint = texture(colortex2, texcoord);

    Light l = getLight();
    vec3 viewPos  = screenToView(texcoord, depth0, gbufferProjectionInverse);
    vec3 viewDir  = normalize(viewPos);
    vec3 worldDir = normalize(mat3(gbufferModelViewInverse) * viewDir);
    float isSky   = step(0.99999, depth0);
    float viewDist = mix(length(viewPos), far, isSky);

    // Water pixels are a coherent region, so this branch is cheap and lets
    // every other pixel skip the SSR cost entirely.
    if (waterData.a > 0.5) {
        color = shadeWater(viewPos, viewDir, waterData, waterTint.rgb, l);
    }

    if (isEyeInWater == 1) {
        // Vanilla underwater fog color carries the biome's water fog hue
        vec3 fogLinear = toLinear(fogColor);
#ifdef WATER_BIOME_TINT
        vec3 tint = fogColor / max(max(fogColor.r, fogColor.g), max(fogColor.b, 0.05));
#else
        vec3 tint = WATER_DEFAULT_TINT;
#endif
        float eyeSky = float(eyeBrightnessSmooth.y) / EYE_BRIGHTNESS_MAX;

#ifdef WATER_CAUSTICS
        vec3 worldPos = viewToWorld(viewPos);
        float caustic = waterCaustics(worldPos.xz, frameTimeCounter * WATER_WAVE_SPEED);
        float notWater = 1.0 - step(0.5, waterData.a);
        color *= 1.0 + caustic * WATER_CAUSTICS_STRENGTH * eyeSky * luminance(l.sun)
                     * exp(-viewDist * CAUSTIC_DIST_FADE) * (1.0 - isSky) * notWater;
#endif
        vec3 transmittance = exp(-waterAbsorption(tint) * viewDist);
        vec3 scatter = waterScatter(tint, l, max(eyeSky, 0.1)) + fogLinear * 0.05;
        color = color * transmittance + scatter * (1.0 - transmittance);
    } else if (isEyeInWater == 2) {
        color = mix(color, LAVA_FOG_COLOR, 1.0 - exp(-viewDist * LAVA_FOG_DENSITY));
    } else if (isEyeInWater == 3) {
        color = mix(color, SNOW_FOG_COLOR * l.ambient, 1.0 - exp(-viewDist * SNOW_FOG_DENSITY));
    } else {
#ifdef BORDER_FOG
        float fog = smoothstep(far * FOG_START, far, viewDist) * (1.0 - isSky);
        color = mix(color, skyAt(worldDir, l), fog);
#endif
    }

    outColor0 = vec4(color, 1.0);
}
