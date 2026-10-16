#version 330 compatibility
// final: linear -> sRGB output (tonemapping comes with the post-process feature)

#include "/lib/common.glsl"

in vec2 texcoord;
uniform sampler2D colortex0;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 outColor;

void main() {
    vec3 color = texture(colortex0, texcoord).rgb;
    outColor = vec4(toSRGB(clamp(color, 0.0, 1.0)), 1.0);
}
