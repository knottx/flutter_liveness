class LivenessResult {
  /// True if live, false if spoof
  final bool isLive;

  /// Sigmoid score, probability of class=1 (spoof)
  final double score;

  /// Laplacian variance
  final int laplacian;

  /// Processing duration
  final Duration duration;

  const LivenessResult({
    required this.isLive,
    required this.score,
    required this.laplacian,
    required this.duration,
  });

  @override
  String toString() {
    return 'LivenessResult(isLive: $isLive, '
        'score: $score, '
        'laplacian: $laplacian, '
        'duration: $duration'
        ')';
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
        other.duration == duration;
  }

  @override
  int get hashCode {
    return Object.hash(
      isLive,
      score,
      laplacian,
      duration,
    );
  }
}
