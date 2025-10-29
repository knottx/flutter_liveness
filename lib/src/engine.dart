import 'package:flutter_liveness/src/image_utils.dart';
import 'package:flutter_liveness/src/laplacian.dart';
import 'package:flutter_liveness/src/liveness_options.dart';
import 'package:flutter_liveness/src/liveness_result.dart';
import 'package:image/image.dart' as imglib;

abstract class ModelRunner {
  /// Returns a single float probability (sigmoid) or a 2-class softmax vector.
  /// We’ll standardize to a **single double** here (probability of class=1).
  Future<double> inferProb(List<List<List<List<double>>>> nhwc);
  Future<void> dispose();
}

class LivenessEngine {
  final ModelRunner _runner;
  final LivenessOptions _opt;

  const LivenessEngine(
    this._runner,
    this._opt,
  );

  Future<LivenessResult> analyze(imglib.Image face) async {
    final lap = _opt.applyLaplacianGate
        ? laplacianScore(
            face,
            inputSize: 224,
            laplacePixelThreshold: _opt.laplacePixelThreshold,
          )
        : 999999; // bypass

    if (_opt.applyLaplacianGate && lap < _opt.laplacianThreshold) {
      return LivenessResult(
        isLive: false,
        score: 0.0,
        laplacian: lap,
        time: Duration.zero,
      );
    }

    final input = toNHWC(face);
    final t0 = DateTime.now();
    final prob1 = await _runner.inferProb(input); // P(spoof)
    final dt = DateTime.now().difference(t0);
    final liveScore = (1.0 - prob1);
    final isLive = liveScore >= _opt.threshold;

    return LivenessResult(
      isLive: isLive,
      score: prob1,
      laplacian: lap,
      time: dt,
    );
  }
}
