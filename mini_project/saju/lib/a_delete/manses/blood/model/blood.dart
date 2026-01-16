import '../../wuxing/graph/wu_xing_graph.dart';

enum Blood {
  bijeon,
  geobjae,
  sikshin,
  sanggwan,
  jeongjae,
  pyeonjae,
  jeonggwan,
  pyeongwan,
  jeongin,
  pyeonin,
}

extension BloodKorean on Blood {
  String get korean {
    switch (this) {
      case Blood.bijeon:
        return '비견';
      case Blood.geobjae:
        return '겁재';
      case Blood.sikshin:
        return '식신';
      case Blood.sanggwan:
        return '상관';
      case Blood.jeongjae:
        return '정재';
      case Blood.pyeonjae:
        return '편재';
      case Blood.jeonggwan:
        return '정관';
      case Blood.pyeongwan:
        return '편관';
      case Blood.jeongin:
        return '정인';
      case Blood.pyeonin:
        return '편인';
    }
  }
}

class BloodKey {
  final WuXingRelationType type;
  final bool samePolarity;

  const BloodKey(this.type, this.samePolarity);

  @override
  bool operator ==(Object other) =>
      other is BloodKey &&
      type == other.type &&
      samePolarity == other.samePolarity;

  @override
  int get hashCode => Object.hash(type, samePolarity);
}
