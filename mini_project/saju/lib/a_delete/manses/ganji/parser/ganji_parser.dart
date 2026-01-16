import '../model/heavenly_stem.dart';

/// 예: "임진(壬辰)" → HeavenlyStem.im
HeavenlyStem parseDayStem(String lunIljin) {
  if (lunIljin.contains('갑')) return HeavenlyStem.gap;
  if (lunIljin.contains('을')) return HeavenlyStem.eul;
  if (lunIljin.contains('병')) return HeavenlyStem.byeong;
  if (lunIljin.contains('정')) return HeavenlyStem.jeong;
  if (lunIljin.contains('무')) return HeavenlyStem.mu;
  if (lunIljin.contains('기')) return HeavenlyStem.gi;
  if (lunIljin.contains('경')) return HeavenlyStem.gyeong;
  if (lunIljin.contains('신')) return HeavenlyStem.sin;
  if (lunIljin.contains('임')) return HeavenlyStem.im;
  return HeavenlyStem.gye;
}
