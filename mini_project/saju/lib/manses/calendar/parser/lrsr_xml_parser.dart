import 'package:xml/xml.dart';
import '../model/lun_cal_item.dart';

class LrsrXmlParser {
  static String _text(XmlElement parent, String tag) =>
      parent.getElement(tag)?.innerText.trim() ?? '';

  static int _int(XmlElement parent, String tag) =>
      int.tryParse(_text(parent, tag)) ?? 0;

  static LunCalItem parseLunCalInfo(String xmlString) {
    final doc = XmlDocument.parse(xmlString);

    final resultCode = doc
        .findAllElements('resultCode')
        .firstOrNull
        ?.innerText
        .trim();
    if (resultCode != '00') {
      final msg = doc
          .findAllElements('resultMsg')
          .firstOrNull
          ?.innerText
          .trim();
      throw StateError('KASI API error: $resultCode / $msg');
    }

    final item = doc.findAllElements('item').firstOrNull;
    if (item == null) throw StateError('No <item> in response');

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
}

/// xml 패키지에 firstOrNull 없음 → 확장
extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
