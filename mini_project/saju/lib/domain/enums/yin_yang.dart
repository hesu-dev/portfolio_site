enum YinYang {
  yang(1, '양', '陽'),
  yin(-1, '음', '陰');

  final int value;
  final String korean;
  final String chinese;

  const YinYang(this.value, this.korean, this.chinese);
}
