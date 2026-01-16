import 'package:saju/a_delete/manses/calendar/model/solar_term.dart';

class SolarTermBase {
  final SolarTerm term;
  final int baseJulDay;

  const SolarTermBase(this.term, this.baseJulDay);
}

// 예시 (실제값은 이후 보정 가능)
const solarTermTable = [
  SolarTermBase(SolarTerm.ipchun, 2459249),
  SolarTermBase(SolarTerm.usu, 2459264),
  // ...
];
