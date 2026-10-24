#version 330 compatibility
// gbuffers_block: pass-through (see lib/programs/gbuffers_generic)
#define USE_TEXTURE
#define USE_LIGHTMAP
#define USE_ALPHA_TEST
#define USE_BLOCK_ENTITY_ID

/* RENDERTARGETS: 0 */
#include "/lib/programs/gbuffers_generic.fsh.glsl"
