#version 330 compatibility
// gbuffers_terrain: pass-through (see lib/programs/gbuffers_generic)
#define USE_TEXTURE
#define USE_LIGHTMAP
#define USE_ALPHA_TEST
#define USE_BLOCK_ID

#include "/lib/programs/gbuffers_generic.vsh.glsl"
