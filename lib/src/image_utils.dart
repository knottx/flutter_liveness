import 'package:image/image.dart' as imglib;

List<List<List<List<double>>>> toNHWC(imglib.Image img) {
  final resized = imglib.copyResize(
    img,
    width: 224,
    height: 224,
  );
  final h = resized.height, w = resized.width;

  double norm(int v) {
    return v / 255.0;
  }

  return List.generate(
    1,
    (_) => List.generate(
      h,
      (i) => List.generate(w, (j) {
        final p = resized.getPixel(j, i);
        return [
          norm(p.r.toInt()),
          norm(p.g.toInt()),
          norm(p.b.toInt()),
        ];
      }),
    ),
  );
}
