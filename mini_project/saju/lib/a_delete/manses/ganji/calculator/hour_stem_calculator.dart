import '../model/heavenly_stem.dart';
import '../model/earthly_branch.dart';

final Map<HeavenlyStem, HeavenlyStem> _hourStartStemByDayStem = {
  HeavenlyStem.gap: HeavenlyStem.gap,
  HeavenlyStem.gi: HeavenlyStem.gap,

  HeavenlyStem.eul: HeavenlyStem.byeong,
  HeavenlyStem.gyeong: HeavenlyStem.byeong,

  HeavenlyStem.byeong: HeavenlyStem.mu,
  HeavenlyStem.sin: HeavenlyStem.mu,

  HeavenlyStem.jeong: HeavenlyStem.gyeong,
  HeavenlyStem.im: HeavenlyStem.gyeong,

  HeavenlyStem.mu: HeavenlyStem.im,
  HeavenlyStem.gye: HeavenlyStem.im,
};

HeavenlyStem calcHourStem(HeavenlyStem dayStem, EarthlyBranch hourBranch) {
  final start = _hourStartStemByDayStem[dayStem];
  if (start == null) {
    throw StateError('Unknown dayStem: $dayStem');
  }

  final idx = (start.index + hourBranch.index) % HeavenlyStem.values.length;
  return HeavenlyStem.values[idx];
}
