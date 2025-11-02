import 'package:flutter_liveness/src/liveness_engine.dart';
import 'package:flutter_liveness/src/liveness_options.dart';
import 'package:flutter_liveness/src/liveness_result.dart';
import 'package:flutter_liveness/src/tflite_runner.dart';
import 'package:image/image.dart' as imglib;

class FlutterLiveness {
  final LivenessEngine _engine;
  final TFLiteRunner _runner;

  const FlutterLiveness._(
    this._engine,
    this._runner,
  );

  static Future<FlutterLiveness> create({
    LivenessOptions options = const LivenessOptions(),
  }) async {
    final runner = await TFLiteRunner.create(
      useGpu: options.useGpu,
      threads: options.threads,
    );
    final engine = LivenessEngine(runner, options);
    return FlutterLiveness._(engine, runner);
  }

  Future<LivenessResult> analyze(imglib.Image face) => _engine.analyze(face);

  Future<void> dispose() => _runner.dispose();
}
