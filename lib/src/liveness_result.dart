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

  @override
  String toString() {
    return 'LivenessResult(isLive: $isLive, score: $score, laplacian: $laplacian, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is LivenessResult &&
        other.isLive == isLive &&
        other.score == score &&
        other.laplacian == laplacian &&
        other.time == time;
  }

  @override
  int get hashCode {
    return Object.hash(
      isLive,
      score,
      laplacian,
      time,
    );
  }
}
