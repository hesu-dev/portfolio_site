import 'package:saju/domain/enums/sky.dart';
import 'package:saju/domain/services/wu_xing_relation.dart';

enum Blood {
  bijyeon,
  geobjye,
  siksin,
  sanggwan,
  jeongjae,
  pyeonjae,
  jeonggwan,
  pyeongwan,
  jeongin,
  pyeonin,
}

class BloodRelationService {
  final WuXingRelation _wx = WuXingRelation.create();

  Blood analyze(Sky day, Sky target) {
    final relation = _wx.analyze(day.wuXing, target.wuXing);
    final samePolarity = day.yinYang == target.yinYang;

    if (relation == WuXingRelationType.same) {
      return samePolarity ? Blood.bijyeon : Blood.geobjye;
    }

    switch (relation) {
      case WuXingRelationType.forwardPositive:
        return samePolarity ? Blood.siksin : Blood.sanggwan;
      case WuXingRelationType.reversePositive:
        return samePolarity ? Blood.jeongjae : Blood.pyeonjae;
      case WuXingRelationType.forwardNegative:
        return samePolarity ? Blood.jeonggwan : Blood.pyeongwan;
      case WuXingRelationType.reverseNegative:
        return samePolarity ? Blood.jeongin : Blood.pyeonin;
      default:
        return Blood.bijyeon;
    }
  }
}
