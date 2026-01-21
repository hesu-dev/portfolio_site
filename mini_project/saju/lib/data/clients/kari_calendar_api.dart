import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saju/domain/models/manse_request_dto.dart';

class CalendarApi {
  final http.Client _client;
  CalendarApi({http.Client? client}) : _client = client ?? http.Client();

  /// PHP 프록시를 통해 XML 문자열을 그대로 가져온다
  Future<String> fetchCalendarXml(ManseRequestDto req) async {
    final type = (req.calendarType == CalendarType.solar) ? 'solar' : 'lunar';

    final uri = Uri.parse(
      'http://sunell.dothome.co.kr/api/solar.php'
      '?year=${req.yyyy}'
      '&month=${req.mm.toString().padLeft(2, '0')}'
      '&day=${req.dd.toString().padLeft(2, '0')}'
      '&type=$type',
    );

    final resp = await _client.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Calendar API 호출 실패: ${resp.statusCode}');
    }

    // PHP에서 내려주는 XML은 UTF-8 기준
    return utf8.decode(resp.bodyBytes);
  }
}
