import 'package:saju/a_delete/manses/blood/model/blood.dart';
import 'package:saju/a_delete/manses/wuxing/calculator/wu_xing_relation_calculator.dart';
import 'package:saju/a_delete/manses/wuxing/graph/wu_xing_graph.dart';
import 'package:saju/a_delete/manses/wuxing/model/wu_xing.dart';

class BloodRelationCalculator {
  final WuXingRelationCalculator _wuXingCalc = WuXingRelationCalculator();

  static final Map<BloodKey, Blood> _map = {
    BloodKey(WuXingRelationType.default_, false): Blood.bijeon,
    BloodKey(WuXingRelationType.default_, true): Blood.geobjae,

    BloodKey(WuXingRelationType.forwardPositive, false): Blood.sikshin,
    BloodKey(WuXingRelationType.forwardPositive, true): Blood.sanggwan,

    BloodKey(WuXingRelationType.reversePositive, false): Blood.jeongjae,
    BloodKey(WuXingRelationType.reversePositive, true): Blood.pyeonjae,

    BloodKey(WuXingRelationType.reverseNegative, false): Blood.jeonggwan,
    BloodKey(WuXingRelationType.reverseNegative, true): Blood.pyeongwan,

    BloodKey(WuXingRelationType.forwardNegative, false): Blood.jeongin,
    BloodKey(WuXingRelationType.forwardNegative, true): Blood.pyeonin,
  };

  Blood analyze({
    required WuXing from,
    required WuXing to,
    required bool samePolarity,
  }) {
    final result = _wuXingCalc.analyzeWuXing(from, to);

    return _map[BloodKey(result.relation, samePolarity)]!;
  }
}
