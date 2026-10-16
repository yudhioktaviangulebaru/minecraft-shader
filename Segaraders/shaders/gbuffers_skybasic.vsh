#version 330 compatibility
// gbuffers_skybasic: sky dome, stars, sunrise fan, void plane

out vec4 glcolor;
out float isStar;

void main() {
    gl_Position = ftransform();
    glcolor = gl_Color;
    // Vanilla stars are grey (r == g == b); the sky dome is tinted.
    isStar = float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0);
}
