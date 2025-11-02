import 'package:flutter_liveness/src/image_to_nhwc.dart';
import 'package:flutter_liveness/src/laplacian.dart';
import 'package:flutter_liveness/src/liveness_options.dart';
import 'package:flutter_liveness/src/liveness_result.dart';
import 'package:flutter_liveness/src/tflite_runner.dart';
import 'package:image/image.dart' as imglib;

class LivenessEngine {
  final TFLiteRunner _runner;
  final LivenessOptions _opt;

  const LivenessEngine(
    this._runner,
    this._opt,
  );

  Future<LivenessResult> analyze(imglib.Image face) async {
    final resized = imglib.copyResize(
      face,
      width: 224,
      height: 224,
    );

    final int laplacian;
    if (_opt.applyLaplacianGate) {
      laplacian = laplacianScore(
        resized,
        laplacePixelThreshold: _opt.laplacePixelThreshold,
      );
    } else {
      /// Bypass laplacian calculation
      laplacian = 999999;
    }

    if (_opt.applyLaplacianGate && laplacian < _opt.laplacianThreshold) {
      return LivenessResult(
        isLive: false,
        score: 1,
        laplacian: laplacian,
        duration: Duration.zero,
      );
    }

    final input = toNHWC(face);
    final t0 = DateTime.now();

    /// Probability of class=1 (spoof)
    final prob1 = await _runner.inferProb(input);

    final dt = DateTime.now().difference(t0);
    final score = (1.0 - prob1);
    final isLive = score >= _opt.threshold;

    return LivenessResult(
      isLive: isLive,
      score: prob1,
      laplacian: laplacian,
      duration: dt,
    );
  }
}
