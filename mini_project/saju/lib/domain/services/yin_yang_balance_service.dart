class YinYangBalance {
  final int yin;
  final int yang;
  final double yinPercent;
  final double yangPercent;
  final String judgment;

  const YinYangBalance({
    required this.yin,
    required this.yang,
    required this.yinPercent,
    required this.yangPercent,
    required this.judgment,
  });
}

class YinYangBalanceService {
  YinYangBalance analyze(List<String> skyList) {
    int yin = 0;
    int yang = 0;

    for (final s in skyList) {
      if ('乙丁己辛癸'.contains(s)) {
        yin++;
      } else {
        yang++;
      }
    }

    final total = yin + yang;
    final yinP = total == 0 ? 0.0 : yin / total * 100;
    final yangP = total == 0 ? 0.0 : yang / total * 100;

    final judgment = yinP > yangP
        ? '음 과다'
        : yangP > yinP
        ? '양 과다'
        : '음양 균형';

    return YinYangBalance(
      yin: yin,
      yang: yang,
      yinPercent: yinP,
      yangPercent: yangP,
      judgment: judgment,
    );
  }
}
