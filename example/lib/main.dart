import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_liveness/flutter_liveness.dart';
import 'package:image/image.dart' as imglib;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_liveness demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLiveness? _liveness;

  LivenessResult? _result;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createLiveness();
    });
  }

  @override
  void dispose() {
    _liveness?.dispose();
    super.dispose();
  }

  Future<void> _createLiveness() async {
    setState(() => _isLoading = true);
    _liveness = await FlutterLiveness.create();
    setState(() => _isLoading = false);
  }

  Future<void> _run() async {
    setState(() => _isLoading = true);
    // Replace with your face crop bytes (asset/file/camera)
    final bytes = await rootBundle.load('assets/sample_face_2.jpg');
    final img = imglib.decodeImage(bytes.buffer.asUint8List());
    if (img == null || _liveness == null) return;
    final result = await _liveness!.analyze(img);
    setState(() {
      _result = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String message;
    if (_result != null) {
      message = [
        'Liveness: ${_result!.isLive ? 'LIVE' : 'SPOOF'}',
        'Score: ${_result!.score.toStringAsFixed(3)}',
        'Laplacian: ${_result!.laplacian.toStringAsFixed(1)}',
        'Duration: ${_result!.duration.inMilliseconds} ms',
      ].join('\n');
    } else {
      message = 'Tap ▶ to analyze';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_liveness demo'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                message,
                textAlign: TextAlign.center,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _run,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
