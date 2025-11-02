import 'package:flutter_liveness/src/image_to_nhwc.dart';
import 'package:flutter_liveness/src/laplacian.dart';
import 'package:flutter_liveness/src/liveness_options.dart';
import 'package:flutter_liveness/src/liveness_result.dart';
import 'package:flutter_liveness/src/tflite_runner.dart';
import 'package:image/image.dart' as img;

class LivenessEngine {
  final TFLiteRunner _runner;
  final LivenessOptions _options;

  const LivenessEngine(
    this._runner,
    this._options,
  );

  Future<LivenessResult> analyze(img.Image face) async {
    final t0 = DateTime.now();

    final img.Image resized;
    if (face.width == 224 && face.height == 224) {
      resized = face;
    } else {
      resized = img.copyResize(face, width: 224, height: 224);
    }

    final int laplacian;
    if (_options.applyLaplacianGate) {
      laplacian = laplacianScore(
        resized,
        laplacePixelThreshold: _options.laplacePixelThreshold,
      );
    } else {
      /// Bypass laplacian calculation
      laplacian = 999999;
    }

    if (_options.applyLaplacianGate &&
        laplacian < _options.laplacianThreshold) {
      return LivenessResult(
        isLive: false,
        score: 1,
        laplacian: laplacian,
        duration: Duration.zero,
      );
    }

    final input = toNHWC(resized);

    /// Probability of class=1 (spoof)
    final prob1 = await _runner.inferProb(input);

    final score = (1.0 - prob1);
    final isLive = score >= _options.threshold;

    final duration = DateTime.now().difference(t0);

    return LivenessResult(
      isLive: isLive,
      score: prob1,
      laplacian: laplacian,
      duration: duration,
    );
  }
}
