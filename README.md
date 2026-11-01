# Pelis420 HD

App Flutter de demostración para Android/iOS: catálogo ficticio, búsqueda, favoritos locales, fichas, reproductor de vídeo y progreso guardado en el dispositivo.

## Ejecutar
```bash
cd mobile
flutter pub get
flutter create --platforms=android,ios --project-name=pelis420_hd .
flutter run
```

## Contenido
Big Buck Bunny es el único vídeo reproducible de la demo (muestra pública de Blender Foundation, CC BY 3.0). Las otras fichas son datos ficticios y no tienen vídeo. Favoritos y progreso se guardan localmente con SharedPreferences.

No incluye backend, usuarios, sincronización multidispositivo, catálogo comercial, descargas offline, DRM ni licencias de películas/series. Para un servicio real, añade fuentes de vídeo propias o autorizadas.

## Descargas
GitHub Actions compila el APK de Android y empaqueta un IPA iOS **sin firma** tras cada push a main. Descarga ambos en la pestaña Actions > ejecución > Artifacts. El IPA debe firmarse con Apple Developer para instalarlo en un iPhone convencional o publicarlo en TestFlight/App Store.

Crea una Release con `git tag v0.2.0 && git push origin v0.2.0`.

La aplicación de ejemplo está bajo MIT. Big Buck Bunny: https://peach.blender.org/ · CC BY 3.0: https://creativecommons.org/licenses/by/3.0/.
