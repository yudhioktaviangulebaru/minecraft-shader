#version 330 compatibility
// gbuffers_damagedblock: pass-through (see lib/programs/gbuffers_generic)
#define USE_TEXTURE
#define USE_ALPHA_TEST
#define KEEP_SRGB

/* RENDERTARGETS: 0 */
#include "/lib/programs/gbuffers_generic.fsh.glsl"
