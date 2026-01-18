import '../enums/sky.dart';
import '../models/manse_request_dto.dart';
import '../models/manse_result_dto.dart';
import '../models/pillar_dto.dart';
import 'time_pillar_service.dart';

class ManseCalculator {
  final TimePillarService _timePillarService;

  ManseCalculator(this._timePillarService);

  /// 서버 없이도 “도메인 유스케이스” 위치는 고정:
  /// Repository가 가져온 년/월/일주 + daySky를 받아 시주를 결합한다.
  ManseResultDto buildResult({
    required ManseRequestDto request,
    required String solarDate,
    required LunarDateDto lunarDate,
    required int julianDay,
    required PillarDto year,
    required PillarDto month,
    required PillarDto day,
  }) {
    final daySky = Sky.fromChinese(day.sky);

    final time = _timePillarService.calculate(
      daySky: daySky,
      hour: request.hour,
      minute: request.minute,
    );

    return ManseResultDto(
      solarDate: solarDate,
      lunarDate: lunarDate,
      julianDay: julianDay,
      timeInput: request.hhmm,
      pillars: MansePillarsDto(year: year, month: month, day: day, time: time),
    );
  }
}
