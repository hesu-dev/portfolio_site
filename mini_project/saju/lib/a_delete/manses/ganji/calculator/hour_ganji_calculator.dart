import '../model/heavenly_stem.dart';
import '../model/earthly_branch.dart';
import 'hour_branch_calculator.dart';
import 'hour_stem_calculator.dart';

/// 시주(時柱) = 시천간 + 시지
String calcHourGanJi({required DateTime birth, required HeavenlyStem dayStem}) {
  final branch = calcHourBranch(birth);
  final stem = calcHourStem(dayStem, branch);

  // UI용 (한글)
  return '${stem.korean}${branch.korean}';
}
