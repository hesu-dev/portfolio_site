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
