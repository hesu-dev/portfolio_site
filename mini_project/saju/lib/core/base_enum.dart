abstract class BaseEnum {
  String get korean;
  String get chinese;

  static String getMultiLang(BaseEnum item, bool useHighlight) {
    if (useHighlight) {
      // Flutter에서는 ANSI 컬러 대신 문자열 강조만 남김
      return '${item.korean}(${item.chinese})';
    }
    return '${item.korean}(${item.chinese})';
  }
}
