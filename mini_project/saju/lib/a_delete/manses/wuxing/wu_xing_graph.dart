import 'wu_xing.dart';
import 'wu_xing_graph_type.dart';

class WuXingGraph {
  final List<List<WuXingGraphType>> matrix;

  WuXingGraph()
    : matrix = List.generate(
        WuXing.values.length,
        (_) => List.filled(WuXing.values.length, WuXingGraphType.defaultType),
      );

  WuXingGraph add(WuXing from, WuXing to, bool isSymbiosis) {
    matrix[from.index][to.index] = isSymbiosis
        ? WuXingGraphType.forwardPositive
        : WuXingGraphType.forwardNegative;

    matrix[to.index][from.index] = isSymbiosis
        ? WuXingGraphType.reversePositive
        : WuXingGraphType.reverseNegative;
    return this;
  }

  WuXingGraphType find(WuXing from, WuXing to) {
    return matrix[from.index][to.index];
  }
}
