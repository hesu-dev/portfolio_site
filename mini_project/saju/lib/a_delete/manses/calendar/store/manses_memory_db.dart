import '../model/lun_cal_item.dart';

class DateKey {
  final int y, m, d;
  const DateKey(this.y, this.m, this.d);

  @override
  bool operator ==(Object other) =>
      other is DateKey && y == other.y && m == other.m && d == other.d;

  @override
  int get hashCode => Object.hash(y, m, d);
}

class MansesMemoryDb {
  final Map<DateKey, LunCalItem> lunBySolar = {};

  LunCalItem? getLun(int y, int m, int d) => lunBySolar[DateKey(y, m, d)];
  void putLun(LunCalItem item) {
    lunBySolar[DateKey(item.solYear, item.solMonth, item.solDay)] = item;
  }

  void clear() => lunBySolar.clear();
}
