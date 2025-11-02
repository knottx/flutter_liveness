import 'package:image/image.dart' as img;

int laplacianScore(
  img.Image resized, {
  required int laplacePixelThreshold,
}) {
  final gray = img.grayscale(resized);
  final bytes = gray.getBytes(order: img.ChannelOrder.red);

  int score = 0;

  for (int x = 1; x < 224 - 2; x++) {
    for (int y = 1; y < 224 - 2; y++) {
      final int index = x * 224 + y;

      final int center = bytes[index];

      final int north = bytes[index - 224];
      final int south = bytes[index + 224];
      final int east = bytes[index + 1];
      final int west = bytes[index - 1];

      // Conv = N + S + E + W - 4*Center
      final int conv = (north + south + east + west) - (4 * center);

      if (conv.abs() > laplacePixelThreshold) {
        score++;
      }
    }
  }
  return score;
}
