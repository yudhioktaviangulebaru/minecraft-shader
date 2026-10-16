#version 330 compatibility
// gbuffers_water: translucent terrain.
//  - Water: leaves colortex0 untouched (alpha 0) and writes surface data
//    (normal, sky light, tint) for composite to shade.
//  - Other translucents (glass, ice, ...): normal blended color, alpha 0 in the
//    data buffers so water data underneath is preserved.

#include "/lib/settings.glsl"
#include "/lib/common.glsl"
#include "/lib/noise.glsl"
#include "/lib/water.glsl"

in vec4 glcolor;
in vec2 texcoord;
in vec2 lmcoord;
in vec3 worldPos;
in vec3 worldNormal;
in float isWater;

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform mat4 gbufferModelView;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

const float LIGHTMAP_MIN   = 1.0 / 32.0; // vanilla lightmap coord range is [1/32, 31/32]
const float LIGHTMAP_SCALE = 16.0 / 15.0;

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 outColor0;    // linear color
layout(location = 1) out vec4 outWaterData; // xy: view normal (octahedral), z: sky light, w: water mask
layout(location = 2) out vec4 outWaterTint; // rgb: water tint (sRGB), a: water mask

void main() {
    vec4 albedo = texture(gtexture, texcoord) * glcolor;
    vec3 lit    = albedo.rgb * texture(lightmap, lmcoord).rgb;

    float viewDist = length(worldPos - cameraPosition);
    vec3 waveNormal = waterNormal(worldPos.xz, frameTimeCounter * WATER_WAVE_SPEED, viewDist);
    float horizontal = step(0.5, abs(worldNormal.y));
    vec3 normal = normalize(mix(worldNormal, waveNormal, horizontal));
    vec3 viewNormal = mat3(gbufferModelView) * normal;

#ifdef WATER_BIOME_TINT
    vec3 tint = glcolor.rgb;
#else
    vec3 tint = WATER_DEFAULT_TINT;
#endif
    float skyLight = saturate((lmcoord.y - LIGHTMAP_MIN) * LIGHTMAP_SCALE);

    outColor0    = mix(vec4(toLinear(lit), albedo.a), vec4(0.0), isWater);
    outWaterData = vec4(encodeNormal(viewNormal), skyLight, 1.0) * isWater;
    outWaterTint = vec4(tint, 1.0) * isWater;
}
