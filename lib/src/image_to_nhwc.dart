import 'package:image/image.dart' as img;

List<List<List<List<double>>>> toNHWC(img.Image resized) {
  final bytes = resized.getBytes(order: img.ChannelOrder.rgb);
  int index = 0;
  return [
    List.generate(
      224,
      (_) => List.generate(224, (_) {
        final r = bytes[index++].toInt() / 255.0;
        final g = bytes[index++].toInt() / 255.0;
        final b = bytes[index++].toInt() / 255.0;

        return [r, g, b];
      }),
    ),
  ];
}
