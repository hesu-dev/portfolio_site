import 'package:saju/a_delete/manses/ganji/ganji.dart';
import '../../core/base_enum.dart';
import '../model/relation_result.dart';
import 'wu_xing.dart';
import 'wu_xing_graph.dart';

class WuXingRelation {
  late final WuXingGraph wuXingGraph;

  String? fromWuXing;
  String? toWuXing;
  String? fromGanJi;
  String? toGanJi;

  WuXingRelation() {
    wuXingGraph = WuXingGraph()
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
  }

  RelationResult analyzeWuXing(WuXing from, WuXing to) {
    fromWuXing = BaseEnum.getMultiLang(from, false);
    toWuXing = BaseEnum.getMultiLang(to, false);
    fromGanJi = null;
    toGanJi = null;

    return RelationResult(relationship: wuXingGraph.find(from, to));
  }

  RelationResult analyzeGanJi(GanJi from, GanJi to) {
    final result = analyzeWuXing(from.wuXing!, to.wuXing!);
    result.isSamePolarity = from.yinYang == to.yinYang;

    fromGanJi = BaseEnum.getMultiLang(from, true);
    toGanJi = BaseEnum.getMultiLang(to, true);
    return result;
  }
}
