import 'package:image/image.dart' as img;

int laplacianScore(
  img.Image resized, {
  required int laplacePixelThreshold,
}) {
  final gray = img.grayscale(resized);
  const kernel = [
    [0, 1, 0],
    [1, -4, 1],
    [0, 1, 0],
  ];
  var score = 0;

  for (var r = 0; r <= gray.height - 3; r++) {
    for (var c = 0; c <= gray.width - 3; c++) {
      var conv = 0;
      for (var kr = 0; kr < 3; kr++) {
        for (var kc = 0; kc < 3; kc++) {
          final px = gray.getPixel(c + kc, r + kr);
          conv += px.r.toInt() * kernel[kr][kc];
        }
      }
      if (conv.abs() > laplacePixelThreshold) score++;
    }
  }
  return score;
}
