# Changelog

## [Unreleased]
### Added
- Daun `exdeorum:infested_leaf` (Ex Deorum) dirender abu-abu (desaturasi) di terrain dan block entity.

## [0.2.0] - 2026-10-16
### Added
- Air realistis:
  - Gelombang vertex prosedural (gelombang berpuncak tajam + dispersi air dalam), tanpa retakan di tepi.
  - Normal gelombang detail per-piksel (oktaf dapat diatur) + riak halus, memudar dengan jarak.
  - Refraksi dengan penolakan sampel di depan permukaan.
  - Penyerapan cahaya per kanal warna dari warna biome (rawa keruh, laut biru pekat) + in-scattering.
  - Pantulan screen-space (SSR) dengan refinement biner dan fallback langit analitik; Fresnel Schlick.
  - Kilau matahari/bulan (Blinn-Phong ternormalisasi).
  - Kaustik di dasar air (diproyeksikan searah cahaya) dan saat berada di bawah air.
  - Buih di garis pantai.
  - Kabut bawah air berbasis warna biome, Snell's window, total internal reflection.
  - Kabut lava dan powder snow.
- Profil LOW / MEDIUM / HIGH / ULTRA dan menu "Air" (EN + ID).
- Validator mengompilasi varian ekstra (semua boolean dibalik, nilai min/max).

## [0.1.0] - 2026-10-16
### Added
- Fondasi: semua program `gbuffers_*` pass-through dalam ruang warna linear (colortex0 RGBA16F).
- Langit gradien analitik sederhana (`gbuffers_skybasic`) dengan glow matahari.
- Kabut tepi (border fog) di `composite` yang menyatu dengan warna langit.
- Konversi linear → sRGB di `final`.
- `tools/validate.sh` dan `tools/package.sh`.
