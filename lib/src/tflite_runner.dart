import 'package:flutter_liveness/src/engine.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class TFLiteRunner implements ModelRunner {
  final tfl.Interpreter _interp;
  final tfl.IsolateInterpreter _iso;

  TFLiteRunner._(this._interp, this._iso);

  /// Loads the **bundled** model from assets in this package.
  static Future<TFLiteRunner> create() async {
    // The asset path under /assets/models in this package:
    const assetPath = 'packages/flutter_liveness/assets/models/model.tflite';
    final i = await tfl.Interpreter.fromAsset(assetPath);
    final iso = await tfl.IsolateInterpreter.create(address: i.address);
    return TFLiteRunner._(i, iso);
  }

  @override
  Future<double> inferProb(List<List<List<List<double>>>> nhwc) async {
    // Many MobileNetV2 binary classifiers export one sigmoid output [1,1] or [1].
    // We'll read it as a 2D shape [1,1] to be safe.
    final output = List.generate(1, (_) => List.filled(1, 0.0));
    final outputs = {0: output};

    await _iso.runForMultipleInputs([nhwc], outputs);

    // Probability of class=1 (model-defined). If your model outputs softmax[2],
    // map it here and return softmax[1] instead.
    final p1 = output[0][0];
    return p1;
  }

  @override
  Future<void> dispose() async {
    await _iso.close();
    _interp.close();
  }
}
