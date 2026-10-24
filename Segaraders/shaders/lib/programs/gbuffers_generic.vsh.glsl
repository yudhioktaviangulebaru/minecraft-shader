// Generic gbuffers vertex program. Feature switches (define before include):
//   USE_TEXTURE, USE_LIGHTMAP, USE_BLOCK_ID (pass mc_Entity id to fragment)

out vec4 glcolor;
#ifdef USE_TEXTURE
out vec2 texcoord;
#endif
#ifdef USE_LIGHTMAP
out vec2 lmcoord;
#endif
#ifdef USE_BLOCK_ID
in vec4 mc_Entity;
flat out int blockId;
#endif

void main() {
    gl_Position = ftransform();
    glcolor = gl_Color;
#ifdef USE_TEXTURE
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
#endif
#ifdef USE_LIGHTMAP
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
#endif
#ifdef USE_BLOCK_ID
    blockId = int(mc_Entity.x + 0.5);
#endif
}
