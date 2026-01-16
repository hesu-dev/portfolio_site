import 'package:saju/a_delete/manses/calendar/model/calendar_result.dart';
import 'package:saju/a_delete/manses/calendar/store/manses_memory_db.dart';

import '../api/lrsr_cld_client.dart';
// import 'package:saju/manses/model/sol_cal_item.dart';
// import 'package:saju/manses/model/jul_day_item.dart';
// import 'package:saju/manses/model/lun_cal_item.dart';
// import '../strategy/calendar_mode.dart';

class MansesCalendarRepo {
  final LrsrCldClient _client;

  MansesCalendarRepo(this._client, MansesMemoryDb read);

  /// 🔹 기본 루트 (양력 기준)
  Future<CalendarResult> fromSolar({required DateTime solar}) async {
    // 1. 음력 정보는 getSolCalInfo 기반으로 확보
    // (주의: SolCalInfo는 음력→양력 API지만,
    //  내부적으로 lun 정보가 함께 내려옴)
    final solCal = await _client.getSolCalInfo(
      lunYear: solar.year,
      lunMonth: solar.month,
      lunDay: solar.day,
      // leapMonth: '평',
    );

    // 2. 율리우스적
    final jul = await _client.getJulDayInfo(solCal.solJd);

    return CalendarResult(
      solar: solar,
      solCal: solCal,
      julDay: jul,
      lunCal: null, // 기본 루트에서는 사용 안 함
    );
  }

  /// 🔹 선택 루트 (음력 기준)
  Future<CalendarResult> fromLunar({
    required int solYear,
    required int solMonth,
    required int solDay,
  }) async {
    final lunCal = await _client.getLunCalInfo(
      solYear: solYear,
      solMonth: solMonth,
      solDay: solDay,
    );

    final jul = await _client.getJulDayInfo(lunCal.solJd);

    return CalendarResult(
      solar: DateTime(solYear, solMonth, solDay),
      solCal: null,
      julDay: jul,
      lunCal: lunCal,
    );
  }
}
