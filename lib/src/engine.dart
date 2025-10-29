import 'package:flutter_liveness/src/image_utils.dart';
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
        score: 1,
        laplacian: lap,
        time: Duration.zero,
      );
    }

    final input = toNHWC(face);
    final t0 = DateTime.now();
    final prob1 = await _runner.inferProb(input); // P(spoof)
    final dt = DateTime.now().difference(t0);
    final score = (1.0 - prob1);
    final isLive = score >= _opt.threshold;

    return LivenessResult(
      isLive: isLive,
      score: score,
      laplacian: lap,
      time: dt,
    );
  }
}
