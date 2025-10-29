class LivenessResult {
  final bool isLive;

  /// Sigmoid score (probability of class=1)
  final double score;

  /// Clarity metric
  final int laplacian;
  final Duration time;

  const LivenessResult({
    required this.isLive,
    required this.score,
    required this.laplacian,
    required this.time,
  });
}
