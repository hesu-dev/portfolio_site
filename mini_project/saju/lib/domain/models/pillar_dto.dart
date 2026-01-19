import 'package:saju/domain/enums/ground.dart';
import 'package:saju/domain/enums/sky.dart';
import 'package:saju/domain/models/blood_mapping_dto.dart';
import 'package:saju/domain/models/manse_result_dto.dart';

class PillarDto {
  final Sky skyEnum;
  final Ground groundEnum;
  final String sky; // 한자 1글자 (예: 甲)
  final String ground; // 한자 1글자 (예: 子)

  const PillarDto({
    required this.skyEnum,
    required this.groundEnum,
    required this.sky,
    required this.ground,
  });

  String get chinese => '$sky$ground';
}

class TimePillarDto extends PillarDto {
  final bool isEarlyZi; // 자시 첫째 시(23:30~00:30)

  const TimePillarDto({
    required super.sky,
    required super.ground,
    required this.isEarlyZi,
    required super.skyEnum,
    required super.groundEnum,
  });
}

class ManseResultDto {
  final String solarDate;
  final LunarDateDto lunarDate;
  final int julianDay;
  final MansePillarsDto pillars;
  final String timeInput;

  // 🔽 추가
  final List<BloodMappingDto> bloodMappings;

  const ManseResultDto({
    required this.solarDate,
    required this.lunarDate,
    required this.julianDay,
    required this.pillars,
    required this.timeInput,
    required this.bloodMappings,
  });
}
