# Pelis420 HD

Aplicación Flutter de inicio para Android e iOS.

## Incluye
- Interfaz inicial en Flutter/Dart con marca **Pelis420 HD**.
- Integración continua para analizar, probar y compilar Android.
- Validación de compilación iOS en macOS.
- Workflow de GitHub Releases activado al publicar una etiqueta `v*`.
- Artefactos Android APK/AAB e IPA iOS sin firma.

## Ejecutar localmente
```bash
cd mobile
flutter pub get
flutter run
```

## Compilaciones en GitHub
En la pestaña **Actions** se ejecutan los workflows al subir cambios. Para generar una Release:
```bash
git tag v0.1.0
git push origin v0.1.0
```

La Release adjunta APK y AAB de Android y un IPA de iOS sin firma.

## iOS: firma y distribución
El IPA generado sin firma no se puede instalar directamente en un iPhone normal. Para TestFlight, App Store o distribución Ad Hoc hacen falta una cuenta Apple Developer, certificado de distribución y perfil de aprovisionamiento. No subas certificados, perfiles ni contraseñas al repositorio.

## Nota legal
Este repositorio es una base de software, no un catálogo de streaming con licencias. Solo conecta fuentes de vídeo y distribuye películas, series o anime para los que tengas derechos de emisión. Los proveedores de metadatos no conceden derechos de reproducción.
