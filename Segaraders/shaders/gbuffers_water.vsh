#version 330 compatibility
// gbuffers_water: translucent terrain. Water gets wave displacement.

#include "/lib/settings.glsl"
#include "/lib/common.glsl"
#include "/lib/noise.glsl"
#include "/lib/water.glsl"

in vec4 mc_Entity;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

out vec4 glcolor;
out vec2 texcoord;
out vec2 lmcoord;
out vec3 worldPos;
out vec3 worldNormal;
out float isWater;

const float SURFACE_EPSILON = 0.01; // blocks; vertices at block bottoms are not displaced

void main() {
    glcolor  = gl_Color;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    vec3 playerPos = (gbufferModelViewInverse * (gl_ModelViewMatrix * gl_Vertex)).xyz;
    worldNormal    = normalize(mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal));
    worldPos       = playerPos + cameraPosition;
    isWater        = float(abs(mc_Entity.x - WATER_BLOCK_ID) < 0.5);

#ifdef WATER_WAVES
    // Displace every vertex lying on the surface height (top faces and the top
    // edge of side faces) so the surface never cracks.
    float heightInBlock = fract(worldPos.y);
    float onSurface = isWater * step(SURFACE_EPSILON, heightInBlock) * step(heightInBlock, 1.0 - SURFACE_EPSILON);
    float wave = waterWaves(worldPos.xz, frameTimeCounter * WATER_WAVE_SPEED, WAVE_VERTEX_OCTAVES);
    playerPos.y += (wave - 1.0) * WATER_WAVE_HEIGHT * onSurface;
#endif

    gl_Position = gl_ProjectionMatrix * (gbufferModelView * vec4(playerPos, 1.0));
}
