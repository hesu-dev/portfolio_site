import 'package:saju/domain/enums/ground.dart';
import 'package:saju/domain/enums/sky.dart';

import '../../core/utils/date_time_utils.dart';
import '../../domain/models/manse_request_dto.dart';
import '../../domain/models/manse_result_dto.dart';
import '../../domain/models/pillar_dto.dart';
import '../../domain/services/manse_calculator.dart';
import '../clients/kari_calendar_api.dart';

class ManseRepository {
  final CalendarApi _api;
  final ManseCalculator _calculator;

  ManseRepository({
    required CalendarApi api,
    required ManseCalculator calculator,
  }) : _api = api,
       _calculator = calculator;

  Future<ManseResultDto> getManse(ManseRequestDto request) async {
    final xml = await _api.fetchCalendarXml(request);
    // item 내부에서 필요한 값만 뽑는다 (정규식)
    final solYear = _tag(xml, 'solYear');
    final solMonth = _tag(xml, 'solMonth');
    final solDay = _tag(xml, 'solDay');
    final solarDate =
        '${solYear.padLeft(4, '0')}-${solMonth.padLeft(2, '0')}-${solDay.padLeft(2, '0')}';

    final lunYear = int.parse(_tag(xml, 'lunYear'));
    final lunMonth = int.parse(_tag(xml, 'lunMonth'));
    final lunDay = int.parse(_tag(xml, 'lunDay'));
    final lunLeap = _tag(xml, 'lunLeapmonth'); // '평'/'윤'
    final lunarDate = LunarDateDto(
      year: lunYear,
      month: lunMonth,
      day: lunDay,
      leap: lunLeap.contains('윤'),
    );

    final julianDay = int.parse(_tag(xml, 'solJd'));

    // 간지 문자열 예: 정축(丁丑)
    final yearGanji = _ganjiChinese(_tag(xml, 'lunSecha')); // 年柱 (간지 2글자)
    final monthGanji = _ganjiChinese(_tag(xml, 'lunWolgeon')); // 月柱
    final dayGanji = _ganjiChinese(_tag(xml, 'lunIljin')); // 日柱

    final yearPillar = PillarDto(
      sky: yearGanji[0],
      ground: yearGanji[1],
      skyEnum: skyFromChinese(yearGanji[0]),
      groundEnum: groundFromChinese(yearGanji[1]),
    );
    final monthPillar = PillarDto(
      sky: monthGanji[0],
      ground: monthGanji[1],
      skyEnum: skyFromChinese(yearGanji[0]),
      groundEnum: groundFromChinese(yearGanji[1]),
    );
    final dayPillar = PillarDto(
      sky: dayGanji[0],
      ground: dayGanji[1],
      skyEnum: skyFromChinese(yearGanji[0]),
      groundEnum: groundFromChinese(yearGanji[1]),
    );

    return _calculator.buildResult(
      request: request,
      solarDate: solarDate,
      lunarDate: lunarDate,
      julianDay: julianDay,
      year: yearPillar,
      month: monthPillar,
      day: dayPillar,
    );
  }

  /// <tag>value</tag> 추출
  String _tag(String xml, String tag) {
    final re = RegExp('<$tag>([^<]+)</$tag>');
    final m = re.firstMatch(xml);
    if (m == null) throw Exception('응답에서 <$tag> 를 찾을 수 없습니다.');
    return m.group(1)!.trim();
  }

  /// "정축(丁丑)" -> "丁丑"
  String _ganjiChinese(String s) {
    final re = RegExp(r'\(([甲乙丙丁戊己庚辛壬癸][子丑寅卯辰巳午未申酉戌亥])\)');
    final m = re.firstMatch(s);
    if (m == null) {
      // 괄호 없는 케이스 대비 (최후 fallback)
      final plain = s.replaceAll(RegExp(r'[^甲乙丙丁戊己庚辛壬癸子丑寅卯辰巳午未申酉戌亥]'), '');
      if (plain.length >= 2) return plain.substring(0, 2);
      throw Exception('간지 문자열 파싱 실패: $s');
    }
    return m.group(1)!;
  }
}
