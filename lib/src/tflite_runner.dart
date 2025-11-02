import 'dart:io';

import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteRunner {
  final Interpreter _interp;
  final IsolateInterpreter _iso;

  const TFLiteRunner._(this._interp, this._iso);

  static Future<TFLiteRunner> create({
    required bool useGpu,
    required int threads,
  }) async {
    const assetPath = 'packages/flutter_liveness/assets/models/model.tflite';
    final options = await _createOptions(useGpu: useGpu, threads: threads);
    final i = await Interpreter.fromAsset(assetPath, options: options);
    final iso = await IsolateInterpreter.create(address: i.address);

    final runner = TFLiteRunner._(i, iso);
    return runner;
  }

  Future<void> dispose() async {
    await _iso.close();
    _interp.close();
  }

  Future<void> warmUp({int times = 3}) async {
    final input = [
      List.generate(
        224,
        (_) => List.generate(
          224,
          (_) => [0.0, 0.0, 0.0],
        ),
      ),
    ];
    for (var i = 0; i < times; i++) {
      await inferProb(input);
    }
  }

  Future<double> inferProb(List<List<List<List<double>>>> nhwc) async {
    final output = List.generate(1, (_) => List.filled(1, 0.0));
    final outputs = {0: output};

    await _iso.runForMultipleInputs([nhwc], outputs);

    // Probability of class=1 (model-defined).
    final p1 = output[0][0];
    return p1;
  }
}

Future<InterpreterOptions> _createOptions({
  required bool useGpu,
  required int threads,
}) async {
  final options = InterpreterOptions();

  if (useGpu) {
    try {
      if (Platform.isAndroid) {
        var gpuDelegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: true,
            inferencePriority1: 2,
          ),
        );
        options.addDelegate(gpuDelegate);
      } else if (Platform.isIOS) {
        var gpuDelegate = GpuDelegate(
          options: GpuDelegateOptions(allowPrecisionLoss: true),
        );
        options.addDelegate(gpuDelegate);
      }
    } catch (e) {
      options.threads = threads;
    }
  } else {
    options.threads = threads;
  }

  return options;
}
