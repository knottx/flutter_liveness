import 'dart:typed_data';

import 'package:image/image.dart' as img;

int laplacianScore(
  img.Image resized, {
  required int laplacePixelThreshold,
}) {
  final w = resized.width;
  final h = resized.height;
  final gray = Uint8List(w * h);
  final bytes = resized.getBytes(order: img.ChannelOrder.rgb);

  for (int i = 0, p = 0; i < gray.length; i++, p += 3) {
    final r = bytes[p];
    final g = bytes[p + 1];
    final b = bytes[p + 2];
    gray[i] = ((77 * r + 150 * g + 29 * b) >> 8);
  }

  int score = 0;

  for (int r = 1; r < h - 1; r++) {
    final rowOffset = r * w;
    for (int c = 1; c < w - 1; c++) {
      final idx = rowOffset + c;
      final center = gray[idx];

      final north = gray[idx - w];
      final south = gray[idx + w];
      final west = gray[idx - 1];
      final east = gray[idx + 1];

      final conv = north + south + west + east - (center << 2);

      if (conv > laplacePixelThreshold || conv < -laplacePixelThreshold) {
        score++;
      }
    }
  }

  return score;
}
