// Segaraders - user options. Every option here must be listed in
// shaders.properties (screen) and have entries in lang/en_us.lang + lang/id_id.lang.

// ---- Atmosphere ----
#define BORDER_FOG                      // Blend distant terrain into the sky
#define FOG_START 0.70 // [0.40 0.50 0.60 0.70 0.80 0.90]

// ---- Water ----
#define WATER_WAVES                     // Vertex wave displacement
#define WATER_WAVE_HEIGHT 0.10 // [0.00 0.05 0.10 0.15 0.20 0.30]
#define WATER_WAVE_SPEED 1.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00]
#define WATER_WAVE_OCTAVES 5 // [3 4 5 6 8]
#define WATER_NORMAL_STRENGTH 1.00 // [0.25 0.50 0.75 1.00 1.50 2.00]
#define WATER_REFLECTIONS 2 // [0 1 2]
#define SSR_STEPS 12 // [8 12 16 24 32 48]
#define SSR_REFINE_STEPS 3 // [0 2 3 4 6]
#define WATER_SUN_SPECULAR 1.00 // [0.00 0.50 1.00 1.50 2.00]
#define WATER_REFRACTION                // Distort what is seen through water
#define WATER_REFRACTION_STRENGTH 1.00 // [0.25 0.50 0.75 1.00 1.50 2.00]
#define WATER_CLARITY 1.00 // [0.25 0.50 0.75 1.00 1.50 2.00 3.00]
#define WATER_BIOME_TINT                // Use biome water color for absorption
#define WATER_CAUSTICS                  // Light patterns on underwater surfaces
#define WATER_CAUSTICS_STRENGTH 1.00 // [0.25 0.50 0.75 1.00 1.50 2.00]
#define WATER_FOAM                      // Foam where water meets the shore
