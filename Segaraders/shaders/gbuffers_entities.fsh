#version 330 compatibility
// gbuffers_entities: pass-through (see lib/programs/gbuffers_generic)
#define USE_TEXTURE
#define USE_LIGHTMAP
#define USE_ALPHA_TEST
#define USE_ENTITY_COLOR

/* RENDERTARGETS: 0 */
#include "/lib/programs/gbuffers_generic.fsh.glsl"
