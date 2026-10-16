// Screen-space reflections: view-space ray march with growing steps and a
// binary-search refinement. Requires settings.glsl, common.glsl.
#ifndef LIB_SSR
#define LIB_SSR

const float SSR_INITIAL_STEP   = 0.4;   // blocks
const float SSR_GROWTH_BUDGET  = 5.0;   // step growth = 1 + budget / steps (fewer steps -> faster growth)
const float SSR_THICKNESS      = 1.5;   // hit tolerance as a multiple of the current step
const float SSR_MIN_THICKNESS  = 0.25;  // blocks
const float SSR_EDGE_FADE      = 0.08;  // fraction of the screen faded at the borders

bool ssrOffscreen(vec3 screenPos) {
    return any(lessThan(screenPos.xy, vec2(0.0))) || any(greaterThan(screenPos.xy, vec2(1.0)));
}

// Returns rgb = reflected color, a = confidence (0 = miss, use sky fallback).
// depthTex should not contain the reflecting surface itself (use depthtex1).
vec4 traceSSR(vec3 origin, vec3 dir, float jitter,
              sampler2D depthTex, sampler2D colorTex, mat4 proj, mat4 projInv) {
    float stepLen = SSR_INITIAL_STEP * (0.75 + 0.5 * jitter);
    float growth  = 1.0 + SSR_GROWTH_BUDGET / float(SSR_STEPS);
    vec3 prevPos  = origin;
    vec3 pos      = origin;

    for (int i = 0; i < SSR_STEPS; i++) {
        prevPos = pos;
        pos += dir * stepLen;
        if (pos.z > -0.05) break;                  // went behind the camera

        vec3 sp = viewToScreen(pos, proj);
        if (ssrOffscreen(sp)) break;

        float sceneZ = screenToView(sp.xy, texture(depthTex, sp.xy).r, projInv).z;
        float diff   = sceneZ - pos.z;             // > 0: ray is behind the scene surface
        if (diff > 0.0 && diff < stepLen * SSR_THICKNESS + SSR_MIN_THICKNESS) {
            vec3 a = prevPos;
            vec3 b = pos;
            for (int j = 0; j < SSR_REFINE_STEPS; j++) {
                vec3 m = (a + b) * 0.5;
                vec3 msp = viewToScreen(m, proj);
                float mz = screenToView(msp.xy, texture(depthTex, msp.xy).r, projInv).z;
                if (mz - m.z > 0.0) b = m; else a = m;
            }
            vec3 hit = viewToScreen(b, proj);
            float hitDepth = texture(depthTex, hit.xy).r;
            vec2 edge = min(hit.xy, 1.0 - hit.xy);
            float fade = smoothstep(0.0, SSR_EDGE_FADE, min(edge.x, edge.y));
            fade *= step(hitDepth, 0.99999);       // hit the sky: let the analytic sky handle it
            return vec4(texture(colorTex, hit.xy).rgb, fade);
        }
        stepLen *= growth;
    }
    return vec4(0.0);
}

#endif
