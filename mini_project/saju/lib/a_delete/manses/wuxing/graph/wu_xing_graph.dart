import '../model/wu_xing.dart';

enum WuXingRelationType {
  default_,
  forwardPositive, // 상생 →
  reversePositive, // 상생 ←
  forwardNegative, // 상극 →
  reverseNegative, // 상극 ←
}

class WuXingGraph {
  final List<List<WuXingRelationType>> matrix;

  WuXingGraph()
    : matrix = List.generate(
        WuXing.values.length,
        (_) => List.filled(WuXing.values.length, WuXingRelationType.default_),
      );

  WuXingGraph add(WuXing from, WuXing to, bool isSymbiosis) {
    matrix[from.index][to.index] = isSymbiosis
        ? WuXingRelationType.forwardPositive
        : WuXingRelationType.forwardNegative;

    matrix[to.index][from.index] = isSymbiosis
        ? WuXingRelationType.reversePositive
        : WuXingRelationType.reverseNegative;
    return this;
  }

  WuXingRelationType find(WuXing from, WuXing to) {
    return matrix[from.index][to.index];
  }
}
