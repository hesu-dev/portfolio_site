import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saju/domain/models/manse_request_dto.dart';

class CalendarApi {
  final http.Client _client;
  CalendarApi({http.Client? client}) : _client = client ?? http.Client();

  /// PHP 프록시를 통해 XML 문자열을 그대로 가져온다
  Future<String> fetchCalendarXml(ManseRequestDto req) async {
    if (true) {
      return _mockCalendarXml;
    }

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

    return utf8.decode(resp.bodyBytes);
  }
}

const String _mockCalendarXml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<response>
  <header>
    <resultCode>00</resultCode>
    <resultMsg>NORMAL SERVICE.</resultMsg>
  </header>
  <body>
    <items>
      <item>
        <lunDay>20</lunDay>
        <lunIljin>을사(乙巳)</lunIljin>
        <lunLeapmonth>평</lunLeapmonth>
        <lunMonth>10</lunMonth>
        <lunNday>30</lunNday>
        <lunSecha>경오(庚午)</lunSecha>
        <lunWolgeon>정해(丁亥)</lunWolgeon>
        <lunYear>1990</lunYear>
        <solDay>06</solDay>
        <solJd>2448232</solJd>
        <solLeapyear>평</solLeapyear>
        <solMonth>12</solMonth>
        <solWeek>목</solWeek>
        <solYear>1990</solYear>
      </item>
    </items>
    <numOfRows>10</numOfRows>
    <pageNo>1</pageNo>
    <totalCount>1</totalCount>
  </body>
</response>
''';
