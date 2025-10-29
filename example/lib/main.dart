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
  FlutterLiveness? liveness;
  LivenessResult? result;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    liveness?.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final l = await FlutterLiveness.create();
    setState(() => liveness = l);
  }

  Future<void> _run() async {
    // Replace with your face crop bytes (asset/file/camera)
    final bytes = await rootBundle.load('assets/sample_face_2.jpg');
    final img = imglib.decodeImage(bytes.buffer.asUint8List());
    if (img == null || liveness == null) return;
    final res = await liveness!.analyze(img);
    setState(() => result = res);
  }

  @override
  Widget build(BuildContext context) {
    final String message;
    if (result != null) {
      message = [
        'Liveness: ${result!.isLive ? 'LIVE' : 'SPOOF'}',
        'Score: ${result!.score.toStringAsFixed(3)}',
        'Laplacian: ${result!.laplacian.toStringAsFixed(1)}',
        'Duration: ${result!.duration.inMilliseconds} ms',
      ].join('\n');
    } else {
      message = 'Tap ▶ to analyze';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_liveness demo'),
      ),
      body: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _run,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
