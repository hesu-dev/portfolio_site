import 'package:saju/domain/blood_relation.dart';

class BloodMappingDto {
  final String pillar; // 년간 / 월간 / 일간 / 시간
  final String targetSky; // 庚, 甲 ...
  final Blood blood; // 십성 enum

  const BloodMappingDto({
    required this.pillar,
    required this.targetSky,
    required this.blood,
  });
}
