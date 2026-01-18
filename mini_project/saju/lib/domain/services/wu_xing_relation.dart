import '../enums/wu_xing.dart';

enum WuXingRelationType {
  same,
  forwardPositive,
  reversePositive,
  forwardNegative,
  reverseNegative,
}

class WuXingRelation {
  final List<List<WuXingRelationType>> matrix;

  WuXingRelation._(this.matrix);

  factory WuXingRelation.create() {
    final size = WuXing.values.length;
    final m = List.generate(
      size,
      (_) => List.filled(size, WuXingRelationType.same),
    );

    void add(WuXing from, WuXing to, bool symbiosis) {
      if (symbiosis) {
        m[from.index][to.index] = WuXingRelationType.forwardPositive;
        m[to.index][from.index] = WuXingRelationType.reversePositive;
      } else {
        m[from.index][to.index] = WuXingRelationType.forwardNegative;
        m[to.index][from.index] = WuXingRelationType.reverseNegative;
      }
    }

    add(WuXing.wood, WuXing.fire, true);
    add(WuXing.wood, WuXing.earth, false);
    add(WuXing.fire, WuXing.earth, true);
    add(WuXing.earth, WuXing.water, false);
    add(WuXing.earth, WuXing.metal, true);
    add(WuXing.water, WuXing.fire, false);
    add(WuXing.metal, WuXing.water, true);
    add(WuXing.fire, WuXing.metal, false);
    add(WuXing.water, WuXing.wood, true);
    add(WuXing.metal, WuXing.wood, false);

    return WuXingRelation._(m);
  }

  WuXingRelationType analyze(WuXing from, WuXing to) {
    return matrix[from.index][to.index];
  }
}
