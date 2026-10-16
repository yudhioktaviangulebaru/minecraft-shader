// Simple analytic sky gradient (placeholder until the atmospheric sky feature).
// Pure function: all inputs are parameters, colors are linear.
#ifndef LIB_SKY
#define LIB_SKY

const float SKY_HORIZON_SHARPNESS = 5.0;  // how fast horizon color fades upward
const float SKY_GROUND_DARKEN     = 0.55; // brightness of the sky below the horizon
const float SKY_SUN_GLOW_POWER    = 8.0;  // width of the glow around the sun
const float SKY_SUN_GLOW_STRENGTH = 0.35;
const vec3  SKY_SUNSET_COLOR      = vec3(1.0, 0.35, 0.08);
const vec3  SKY_NOON_GLOW_COLOR   = vec3(1.0, 0.90, 0.70);

// dir, sunDir: normalized world-space directions
vec3 computeSky(vec3 dir, vec3 sunDir, vec3 zenithColor, vec3 horizonColor) {
    float upness  = max(dir.y, 0.0);
    float horizon = exp(-upness * SKY_HORIZON_SHARPNESS);
    vec3 col = mix(zenithColor, horizonColor, horizon);

    // Below the horizon fade to a darker horizon color
    col = mix(col, horizonColor * SKY_GROUND_DARKEN, smoothstep(0.0, -0.3, dir.y));

    // Sun glow, warmer near sunrise/sunset
    float sunAmount = max(dot(dir, sunDir), 0.0);
    vec3 glowColor  = mix(SKY_SUNSET_COLOR, SKY_NOON_GLOW_COLOR, smoothstep(-0.05, 0.4, sunDir.y));
    float sunUp     = smoothstep(-0.2, 0.1, sunDir.y);
    col += glowColor * pow(sunAmount, SKY_SUN_GLOW_POWER) * SKY_SUN_GLOW_STRENGTH * sunUp * (0.4 + horizon);

    return col;
}

#endif
