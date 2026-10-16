// Generic gbuffers fragment program. Writes linear color to colortex0.
// Feature switches (define before include):
//   USE_TEXTURE, USE_LIGHTMAP, USE_ALPHA_TEST, USE_ENTITY_COLOR,
//   KEEP_SRGB (for multiplicative overlays such as block breaking cracks)

#include "/lib/common.glsl"

in vec4 glcolor;
#ifdef USE_TEXTURE
in vec2 texcoord;
uniform sampler2D gtexture;
#endif
#ifdef USE_LIGHTMAP
in vec2 lmcoord;
uniform sampler2D lightmap;
#endif
#ifdef USE_ENTITY_COLOR
uniform vec4 entityColor; // hurt / creeper flash
#endif

layout(location = 0) out vec4 outColor0;

void main() {
    vec4 albedo = glcolor;
#ifdef USE_TEXTURE
    albedo *= texture(gtexture, texcoord);
#endif
#ifdef USE_ALPHA_TEST
    if (albedo.a < ALPHA_CUTOFF) discard;
#endif
#ifdef USE_ENTITY_COLOR
    albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);
#endif
#ifdef USE_LIGHTMAP
    albedo.rgb *= texture(lightmap, lmcoord).rgb;
#endif
#ifdef KEEP_SRGB
    outColor0 = albedo;
#else
    outColor0 = vec4(toLinear(albedo.rgb), albedo.a);
#endif
}
