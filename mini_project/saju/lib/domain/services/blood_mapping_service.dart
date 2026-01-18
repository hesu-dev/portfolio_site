class BloodMapping {
  final String pillar;
  final String blood;

  BloodMapping(this.pillar, this.blood);
}

class BloodMappingService {
  List<BloodMapping> analyze({
    required String daySky,
    required Map<String, String> targets,
  }) {
    // targets: { '년간': '庚', '월간': '甲', ... }
    return targets.entries.map((e) {
      final blood = _calcBlood(daySky, e.value);
      return BloodMapping(e.key, blood);
    }).toList();
  }

  String _calcBlood(String day, String target) {
    // 단순 규칙 기반 (기존 Blood enum 대체)
    if (day == target) return '비견';
    if (_isSameWuXing(day, target)) return '겁재';
    // 실제 네 BloodRelation 이식해서 교체 예정
    return '기타';
  }

  bool _isSameWuXing(String a, String b) {
    const map = {
      '甲': '목',
      '乙': '목',
      '丙': '화',
      '丁': '화',
      '戊': '토',
      '己': '토',
      '庚': '금',
      '辛': '금',
      '壬': '수',
      '癸': '수',
    };
    return map[a] == map[b];
  }
}
