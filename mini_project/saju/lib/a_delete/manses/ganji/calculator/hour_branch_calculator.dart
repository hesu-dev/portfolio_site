import '../model/earthly_branch.dart';

/// 시지(時支) 계산
EarthlyBranch calcHourBranch(DateTime birth) {
  final h = birth.hour;

  // 자시: 23:00 ~ 00:59
  if (h == 23 || h == 0) return EarthlyBranch.ja;
  if (h <= 2) return EarthlyBranch.chuk;
  if (h <= 4) return EarthlyBranch.in_;
  if (h <= 6) return EarthlyBranch.myo;
  if (h <= 8) return EarthlyBranch.jin;
  if (h <= 10) return EarthlyBranch.sa;
  if (h <= 12) return EarthlyBranch.o;
  if (h <= 14) return EarthlyBranch.mi;
  if (h <= 16) return EarthlyBranch.sin;
  if (h <= 18) return EarthlyBranch.yu;
  if (h <= 20) return EarthlyBranch.sul;
  return EarthlyBranch.hae;
}
