import '../ganji/ganji.dart';
import '../wuxing/wu_xing_relation.dart';
import 'blood.dart';

class BloodRelation {
  final WuXingRelation _wuXingRelation;

  BloodRelation() : _wuXingRelation = WuXingRelation();

  Blood? analyze(GanJi from, GanJi to) {
    final result = _wuXingRelation.analyzeGanJi(from, to);
    return Blood.fromRelation(result);
  }
}
