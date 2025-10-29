## 1.0.0

- On-device face liveness / anti-spoofing detection
- Bundled MobileNetV2 TFLite model (MIT licensed)
- Image normalization + resize pipeline
- Laplacian blur / clarity filter
- TensorFlow Lite isolate execution for performance
- Simple async API:
  - FlutterLiveness.create()
  - liveness.analyze(img)
  - liveness.dispose()
- Works offline, real-time capable
- Configurable thresholds & options
