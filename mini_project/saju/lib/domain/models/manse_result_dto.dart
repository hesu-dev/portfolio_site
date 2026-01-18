import 'pillar_dto.dart';

class LunarDateDto {
  final int year;
  final int month;
  final int day;
  final bool leap;

  const LunarDateDto({
    required this.year,
    required this.month,
    required this.day,
    required this.leap,
  });
}

class MansePillarsDto {
  final PillarDto year;
  final PillarDto month;
  final PillarDto day;
  final TimePillarDto time;

  const MansePillarsDto({
    required this.year,
    required this.month,
    required this.day,
    required this.time,
  });
}

class ManseResultDto {
  final String solarDate; // "YYYY-MM-DD"
  final LunarDateDto lunarDate;
  final int julianDay;
  final MansePillarsDto pillars;
  final String timeInput; // "HH:mm"

  const ManseResultDto({
    required this.solarDate,
    required this.lunarDate,
    required this.julianDay,
    required this.pillars,
    required this.timeInput,
  });
}
