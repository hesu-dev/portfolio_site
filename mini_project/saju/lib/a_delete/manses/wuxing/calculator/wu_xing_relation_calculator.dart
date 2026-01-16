import '../graph/wu_xing_graph.dart';
import '../model/wu_xing.dart';

class WuXingRelationResult {
  final WuXingRelationType relation;
  final bool? isSamePolarity;

  WuXingRelationResult(this.relation, this.isSamePolarity);
}

class WuXingRelationCalculator {
  final WuXingGraph _graph;

  WuXingRelationCalculator()
    : _graph = WuXingGraph()
        ..add(WuXing.wood, WuXing.fire, true)
        ..add(WuXing.wood, WuXing.earth, false)
        ..add(WuXing.fire, WuXing.earth, true)
        ..add(WuXing.earth, WuXing.water, false)
        ..add(WuXing.earth, WuXing.metal, true)
        ..add(WuXing.water, WuXing.fire, false)
        ..add(WuXing.metal, WuXing.water, true)
        ..add(WuXing.fire, WuXing.metal, false)
        ..add(WuXing.water, WuXing.wood, true)
        ..add(WuXing.metal, WuXing.wood, false);

  WuXingRelationResult analyzeWuXing(WuXing from, WuXing to) {
    final r = _graph.find(from, to);
    return WuXingRelationResult(r, null);
  }
}
