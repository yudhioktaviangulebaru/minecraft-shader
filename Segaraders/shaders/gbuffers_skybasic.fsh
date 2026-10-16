#version 330 compatibility
// gbuffers_skybasic: replace vanilla sky dome with an analytic gradient

#include "/lib/common.glsl"
#include "/lib/sky.glsl"

in vec4 glcolor;
in float isStar;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
uniform vec3 skyColor;
uniform vec3 fogColor;
uniform float viewWidth;
uniform float viewHeight;

const float STAR_BRIGHTNESS = 1.5;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 outColor0;

void main() {
    vec2 uv       = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    vec3 viewPos  = screenToView(uv, 1.0, gbufferProjectionInverse);
    vec3 worldDir = normalize(mat3(gbufferModelViewInverse) * viewPos);
    vec3 sunDir   = normalize(mat3(gbufferModelViewInverse) * sunPosition);

    vec3 sky  = computeSky(worldDir, sunDir, toLinear(skyColor), toLinear(fogColor));
    vec3 star = toLinear(glcolor.rgb) * STAR_BRIGHTNESS;

    outColor0 = vec4(mix(sky, star, isStar), mix(1.0, glcolor.a, isStar));
}
