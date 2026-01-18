enum Ground {
  zi('자', '子'),
  chou('축', '丑'),
  yin('인', '寅'),
  mao('묘', '卯'),
  chen('진', '辰'),
  si('사', '巳'),
  wu('오', '午'),
  wei('미', '未'),
  shen('신', '申'),
  you('유', '酉'),
  xu('술', '戌'),
  hai('해', '亥');

  final String korean;
  final String chinese;
  const Ground(this.korean, this.chinese);

  int get index1to12 => index + 1;

  static Ground fromChinese(String c) =>
      Ground.values.firstWhere((e) => e.chinese == c);
}

Ground groundFromChinese(String ch) {
  switch (ch) {
    case '子':
      return Ground.zi;
    case '丑':
      return Ground.chou;
    case '寅':
      return Ground.yin;
    case '卯':
      return Ground.mao;
    case '辰':
      return Ground.chen;
    case '巳':
      return Ground.si;
    case '午':
      return Ground.wu;
    case '未':
      return Ground.wei;
    case '申':
      return Ground.shen;
    case '酉':
      return Ground.you;
    case '戌':
      return Ground.xu;
    case '亥':
      return Ground.hai;
    default:
      throw Exception('Unknown Ground chinese: $ch');
  }
}
