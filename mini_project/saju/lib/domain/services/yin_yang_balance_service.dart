class YinYangBalance {
  final int yin;
  final int yang;
  final double yinPercent;
  final double yangPercent;
  final String judgment;
  final String keyPoints;
  final String comment;

  const YinYangBalance({
    required this.yin,
    required this.yang,
    required this.yinPercent,
    required this.yangPercent,
    required this.judgment,
    required this.keyPoints,
    required this.comment,
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

    late final String judgment;
    late final String keyPoints;
    late final String comment;

    if (yinP > yangP) {
      judgment = '음(陰)이\n높음';
      keyPoints = '당신은..내향적, 신중함, 관찰 중심입니다. 생각은 깊지만 실행이 늦어질 수 있으니 유의합시다.';
      comment =
          '생각이 깊고 신중한 성향이 강합니다. 혼자 정리하고 판단하는 힘은 뛰어나지만, '
          '결정이 늦어지거나 기회를 흘려보낼 수 있습니다.\n'
          '내면 에너지가 강해 감정과 사고의 밀도가 높습니다. '
          '다만 지나친 고민은 피로로 이어질 수 있으니 의식적인 행동 전환이 필요합니다.\n'
          '조용하지만 단단한 기질을 지녔습니다. 외부 자극보다는 내적 안정이 중요하며, '
          '휴식과 정리가 운의 흐름에 도움 됩니다.';
    } else if (yangP > yinP) {
      judgment = '양(陽)이\n높음';
      keyPoints = '당신은..외향적, 추진력, 행동 중심입니다. 속도는 빠르나 소진 역시 빠르니 주의합니다.';
      comment =
          '행동력과 추진력이 강한 구조입니다. 기회를 빠르게 포착하는 장점이 있으나, '
          '무리한 선택이나 에너지 소모에 주의가 필요합니다.\n'
          '외부 활동과 표현력이 뛰어나 리더십이 드러나기 쉽습니다. '
          '다만 멈추고 점검하는 시간이 부족해질 수 있습니다.\n'
          '에너지가 바깥으로 강하게 뻗는 타입이므로 완급 조절이 운의 안정에 중요합니다.';
    } else {
      judgment = '음양(陰陽)\n조화로움';
      keyPoints = '당신은..조화, 안정, 균형 감각 지속력과 판단력 우수한 편입니다.';
      comment =
          '음과 양의 균형이 잘 잡힌 구조입니다. 상황 판단이 안정적이며 '
          '무리 없이 흐름을 이어가는 힘이 있습니다.\n'
          '생각과 행동의 조화가 좋아 장기적으로 운을 운용하기에 유리한 기질입니다.\n'
          '큰 기복 없이 꾸준함을 유지할 수 있으며, 다양한 환경에 유연하게 대응할 수 있습니다.';
    }

    return YinYangBalance(
      yin: yin,
      yang: yang,
      yinPercent: yinP,
      yangPercent: yangP,
      judgment: judgment,
      keyPoints: keyPoints,
      comment: comment,
    );
  }
}
