import 'wu_xing.dart';
import 'yin_yang.dart';

enum Sky {
  gap(1, '갑', '甲', WuXing.wood, YinYang.yang),
  eul(2, '을', '乙', WuXing.wood, YinYang.yin),
  byeong(3, '병', '丙', WuXing.fire, YinYang.yang),
  jeong(4, '정', '丁', WuXing.fire, YinYang.yin),
  mu(5, '무', '戊', WuXing.earth, YinYang.yang),
  gi(6, '기', '己', WuXing.earth, YinYang.yin),
  gyeong(7, '경', '庚', WuXing.metal, YinYang.yang),
  sin(8, '신', '辛', WuXing.metal, YinYang.yin),
  im(9, '임', '壬', WuXing.water, YinYang.yang),
  gye(10, '계', '癸', WuXing.water, YinYang.yin);

  final int idx; // 1..10
  final String korean;
  final String chinese;
  final WuXing wuXing;
  final YinYang yinYang;

  const Sky(this.idx, this.korean, this.chinese, this.wuXing, this.yinYang);

  static Sky fromIdx(int idx1to10) =>
      Sky.values.firstWhere((e) => e.idx == idx1to10);

  static Sky fromChinese(String c) =>
      Sky.values.firstWhere((e) => e.chinese == c);
}

Sky skyFromChinese(String ch) {
  switch (ch) {
    case '甲':
      return Sky.gap;
    case '乙':
      return Sky.eul;
    case '丙':
      return Sky.byeong;
    case '丁':
      return Sky.jeong;
    case '戊':
      return Sky.mu;
    case '己':
      return Sky.gi;
    case '庚':
      return Sky.gyeong;
    case '辛':
      return Sky.sin;
    case '壬':
      return Sky.im;
    case '癸':
      return Sky.gye;
    default:
      throw Exception('Unknown Sky chinese: $ch');
  }
}
