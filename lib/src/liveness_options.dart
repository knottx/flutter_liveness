class LivenessOptions {
  /// Decision thresholds sigmoid cutoff; default 0.5
  final double threshold;

  /// Blur gate on/off
  final bool applyLaplacianGate;

  /// Min clarity to proceed
  final int laplacianThreshold;

  /// Conv threshold
  final int laplacePixelThreshold;

  const LivenessOptions({
    this.threshold = 0.5,
    this.applyLaplacianGate = true,
    this.laplacianThreshold = 1000,
    this.laplacePixelThreshold = 50,
  });

  LivenessOptions copyWith({
    double? threshold,
    bool? applyLaplacianGate,
    int? laplacianThreshold,
    int? laplacePixelThreshold,
  }) {
    return LivenessOptions(
      threshold: threshold ?? this.threshold,
      applyLaplacianGate: applyLaplacianGate ?? this.applyLaplacianGate,
      laplacianThreshold: laplacianThreshold ?? this.laplacianThreshold,
      laplacePixelThreshold:
          laplacePixelThreshold ?? this.laplacePixelThreshold,
    );
  }
}
