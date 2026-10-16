# Segaraders

Shader pack realistis untuk **Minecraft Java 1.20.1** (Forge 47.x + OptiFine HD U I6,
kompatibel dengan Oculus). Fokus utama: air yang realistis dengan prioritas performa.

## Instalasi
1. Salin `dist/Segaraders-vX.Y.Z.zip` ke `.minecraft/shaderpacks/`.
2. Options → Video Settings → Shaders → pilih **Segaraders**.
3. Pilih profil (Low / Medium / High / Ultra) di menu Shader Options.

## Pengembangan
- `tools/validate.sh` — validasi GLSL (glslang) untuk semua profil, cek RENDERTARGETS,
  varying vsh↔fsh, dan pendaftaran opsi menu + lang.
- `tools/package.sh` — validasi lalu buat `dist/Segaraders-v<VERSION>.zip`.
- Versi pack ada di file `VERSION`.

## Buffer
| Buffer    | Format  | Isi                                                     |
|-----------|---------|---------------------------------------------------------|
| colortex0 | RGBA16F | Warna scene (linear)                                    |
| colortex1 | RGBA16  | Data air: xy = normal view (oktahedral), z = sky light, w = mask air |
| colortex2 | RGBA8   | rgb = warna biome air (sRGB), a = mask air              |

## Cara kerja air
1. `gbuffers_water.vsh` — gelombang vertex (3 oktaf) pada permukaan air (`mc_Entity` 10008).
2. `gbuffers_water.fsh` — air **tidak** menulis warna ke colortex0 (alpha 0), hanya normal
   gelombang detail + sky light + warna biome ke colortex1/2. Kaca/es tetap di-blend normal.
3. `composite.fsh` — refraksi, penyerapan cahaya per kanal (Beer–Lambert, dari warna biome),
   in-scattering, pantulan SSR + langit, Fresnel (Schlick, F0 = 0.02), kilau matahari,
   kaustik, buih pantai, kabut bawah air, dan Snell's window / total internal reflection
   saat melihat permukaan dari bawah.
