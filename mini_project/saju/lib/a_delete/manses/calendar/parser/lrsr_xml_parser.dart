import 'package:saju/a_delete/manses/model/jul_day_item.dart';
import 'package:saju/a_delete/manses/model/sol_cal_item.dart';
import 'package:xml/xml.dart';

import '../model/lun_cal_item.dart';

class LrsrXmlParser {
  // ---------- 공통 유틸 ----------
  static String _text(XmlElement parent, String tag) {
    return parent.getElement(tag)?.innerText.trim() ?? '';
  }

  static int _int(XmlElement parent, String tag) {
    return int.tryParse(_text(parent, tag)) ?? 0;
  }

  static void _checkResult(XmlDocument doc) {
    final code = doc
        .findAllElements('resultCode')
        .firstOrNull
        ?.innerText
        .trim();
    if (code != '00') {
      final msg = doc
          .findAllElements('resultMsg')
          .firstOrNull
          ?.innerText
          .trim();
      throw StateError('KASI API error: $code / $msg');
    }
  }

  // ---------- 1. 음력일 정보 ----------
  static LunCalItem parseLunCalInfo(String xml) {
    final doc = XmlDocument.parse(xml);
    _checkResult(doc);

    final item = doc.findAllElements('item').firstOrNull;
    if (item == null) {
      throw StateError('No <item> in getLunCalInfo response');
    }

    return LunCalItem(
      solYear: _int(item, 'solYear'),
      solMonth: _int(item, 'solMonth'),
      solDay: _int(item, 'solDay'),
      lunYear: _int(item, 'lunYear'),
      lunMonth: _int(item, 'lunMonth'),
      lunDay: _int(item, 'lunDay'),
      lunLeapmonth: _text(item, 'lunLeapmonth'),
      solLeapyear: _text(item, 'solLeapyear'),
      solWeek: _text(item, 'solWeek'),
      lunSecha: _text(item, 'lunSecha'),
      lunWolgeon: _text(item, 'lunWolgeon'),
      lunIljin: _text(item, 'lunIljin'),
      lunNday: _int(item, 'lunNday'),
      solJd: _int(item, 'solJd'),
    );
  }

  // ---------- 2. 양력일 정보 ----------
  static SolCalItem parseSolCalInfo(String xmlString) {
    final cleaned = xmlString.replaceAll(RegExp(r'<script[^>]*\/>'), '');

    print('XML RAW:\n$xmlString');
    print('XML CLEANED:\n$cleaned');

    // ✅ ② 그 다음에 파싱
    final document = XmlDocument.parse(cleaned);
    final item = document.findAllElements('item').first;

    String text(String name) => item.getElement(name)?.innerText.trim() ?? '';

    // print(text('lunIljin'));
    return SolCalItem(
      lunYear: int.parse(text('lunYear')),
      lunMonth: int.parse(text('lunMonth')),
      lunDay: int.parse(text('lunDay')),
      lunLeapmonth: text('lunLeapmonth'),
      lunIljin: text('lunIljin'), // ← 여기서 확정
      lunSecha: text('lunSecha'),
      lunWolgeon: text('lunWolgeon'),
      solYear: int.parse(text('solYear')),
      solMonth: int.parse(text('solMonth')),
      solDay: int.parse(text('solDay')),
      solJd: int.parse(text('solJd')),
    );
  }

  // ---------- 3. 율리우스적 ----------
  static JulDayItem parseJulDayInfo(String xml) {
    final doc = XmlDocument.parse(xml);
    _checkResult(doc);

    final item = doc.findAllElements('item').firstOrNull;
    if (item == null) {
      throw StateError('No <item> in getJulDayInfo response');
    }

    return JulDayItem(
      solYear: _int(item, 'solYear'),
      solMonth: _int(item, 'solMonth'),
      solDay: _int(item, 'solDay'),
      julDay: _int(item, 'solJd'),
    );
  }
}

/// xml 패키지에 firstOrNull이 없어서 확장
extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
