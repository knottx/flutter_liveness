class LivenessOptions {
  /// Use GPU for processing
  final bool useGpu;

  /// Number of threads for CPU inference
  final int cpuThreads;

  /// Liveness threshold
  final double threshold;

  /// Whether to apply laplacian gate
  final bool applyLaplacianGate;

  /// Laplacian variance threshold
  final int laplacianThreshold;

  /// Number of pixels that must exceed the laplacianThreshold
  final int laplacePixelThreshold;

  const LivenessOptions({
    this.useGpu = false,
    this.cpuThreads = 4,
    this.threshold = 0.5,
    this.applyLaplacianGate = true,
    this.laplacianThreshold = 3000,
    this.laplacePixelThreshold = 50,
  });

  @override
  String toString() {
    return 'LivenessOptions(useGpu: $useGpu, '
        'cpuThreads: $cpuThreads, '
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
        other.cpuThreads == cpuThreads &&
        other.threshold == threshold &&
        other.applyLaplacianGate == applyLaplacianGate &&
        other.laplacianThreshold == laplacianThreshold &&
        other.laplacePixelThreshold == laplacePixelThreshold;
  }

  @override
  int get hashCode {
    return Object.hash(
      useGpu,
      cpuThreads,
      threshold,
      applyLaplacianGate,
      laplacianThreshold,
      laplacePixelThreshold,
    );
  }
}
