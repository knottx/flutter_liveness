class LivenessOptions {
  /// Use GPU for processing
  final bool useGpu;

  /// Decision thresholds sigmoid cutoff; default 0.5
  final double threshold;

  /// Blur gate on/off
  final bool applyLaplacianGate;

  /// Min clarity to proceed
  final int laplacianThreshold;

  /// Conv threshold
  final int laplacePixelThreshold;

  const LivenessOptions({
    this.useGpu = false,
    this.threshold = 0.5,
    this.applyLaplacianGate = true,
    this.laplacianThreshold = 6000,
    this.laplacePixelThreshold = 20,
  });

  @override
  String toString() {
    return 'LivenessOptions(useGpu: $useGpu, '
        'threshold: $threshold, '
        'applyLaplacianGate: $applyLaplacianGate, '
        'laplacianThreshold: $laplacianThreshold, '
        'laplacePixelThreshold: $laplacePixelThreshold'
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
    return other is LivenessOptions &&
        other.useGpu == useGpu &&
        other.threshold == threshold &&
        other.applyLaplacianGate == applyLaplacianGate &&
        other.laplacianThreshold == laplacianThreshold &&
        other.laplacePixelThreshold == laplacePixelThreshold;
  }

  @override
  int get hashCode {
    return Object.hash(
      useGpu,
      threshold,
      applyLaplacianGate,
      laplacianThreshold,
      laplacePixelThreshold,
    );
  }
}
