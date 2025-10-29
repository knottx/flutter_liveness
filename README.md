# flutter_liveness

![Model: MobileNetV2](https://img.shields.io/badge/Model-MobileNetV2-blue)
![Dataset: Spoof/Real](https://img.shields.io/badge/Data-Liveness-red)
![License: MIT](https://img.shields.io/badge/License-MIT-green)

Lightweight on-device face liveness detection for Flutter, powered by MobileNetV2 from open liveness research.

## ✨ Features

- On-device liveness detection — no server required
- Ships with pre-trained MobileNetV2 model
- Uses TensorFlow Lite — optimized for real-time
- Simple API — plug & play
- Blur & clarity detector (Laplacian filter)

## 🧠 Model Information

This package uses a pre-trained MobileNetV2 face liveness model trained as described in:

> Using MobileNetV2 ([Zawar, et al., 2023](https://www.atlantis-press.com/proceedings/acvait-22/125989871))
>
> From the open-source project: [biometric-technologies/liveness-detection-model](https://github.com/biometric-technologies/liveness-detection-model)

Model licensed under MIT, included with attribution.

Class meaning:

- 0 = real
- 1 = spoof

## 🚀 Usage

### Initialize

```dart
import 'package:flutter_liveness/flutter_liveness.dart';
import 'package:image/image.dart' as imglib;

late final FlutterLiveness liveness;

Future<void> initLiveness() async {
  liveness = await FlutterLiveness.create();
}
```

### Analyze a face image

```dart
Future<void> check(Uint8List faceBytes) async {
  final img = imglib.decodeImage(faceBytes);
  if (img == null) throw Exception("Invalid image");

  final result = await liveness.analyze(img);

  print("Live: ${result.isLive}");
  print("Score (P(spoof)): ${result.score}");
  print("Laplacian: ${result.laplacian}");
  print("Inference time: ${result.duration.inMilliseconds} ms");
}
```

### Cleanup

```dart
@override
void dispose() {
  liveness.dispose();
  super.dispose();
}
```

## 📊 Output Example

```txt
Live: true
Score (P(spoof)): 0.023
Clarity (laplacian): 1812
Inference time: 29 ms
```

## ⚙️ Settings

You can tune thresholds:

```dart
final liveness = await FlutterLiveness.create(
  options: LivenessOptions(
    threshold: 0.5, // sigmoid cutoff
    laplacianThreshold: 1000, // blur block
  ),
);
```

## ❗ Usage Notes

- Feed cropped face images (not full camera frames)
- Calls are fast (~20–35ms on modern devices)
- Throttle analysis: ~3–5 FPS recommended
- Do not consider this as the only security mechanism for KYC/financial apps — use it as one signal in a trust pipeline

## 📱 Integration Tips

- Use camera plugin to stream frames
- Detect faces with MLKit or any detector
- Crop → send to liveness.analyze()
- Combine with:
  - Face presence
  - Eye blink / movement (optional future enhancement)
  - Anti-tampering / screen detection

## 🔐 Disclaimer

This library provides liveness estimation, not identity verification.
Use responsibly and evaluate for your use-case security requirements.

## 🤝 Acknowledgements

- TensorFlow Lite team
- Biometric Technologies OÜ for the model & research
- Flutter community
