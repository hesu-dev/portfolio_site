import 'package:saju/domain/models/pillar_dto.dart';

import '../enums/wu_xing.dart';

class WuXingDistribution {
  final Map<WuXing, int> count;
  final Map<WuXing, double> percent;

  const WuXingDistribution(this.count, this.percent);
}

class WuXingDistributionService {
  WuXingDistribution analyze(ManseResultDto result) {
    final map = {
      WuXing.wood: 0,
      WuXing.fire: 0,
      WuXing.earth: 0,
      WuXing.metal: 0,
      WuXing.water: 0,
    };

    // 년/월/일/시 천간 오행 집계
    final skies = [
      result.pillars.year.sky,
      result.pillars.month.sky,
      result.pillars.day.sky,
      result.pillars.time.sky,
    ];

    for (final c in skies) {
      final wx = _skyToWuXing(c);
      map[wx] = map[wx]! + 1;
    }

    final total = map.values.fold<int>(0, (a, b) => a + b);
    final percent = {
      for (final e in map.entries)
        e.key: total == 0 ? 0.0 : (e.value / total * 100),
    };

    return WuXingDistribution(map, percent);
  }

  WuXing _skyToWuXing(String chineseSky) {
    switch (chineseSky) {
      case '甲':
      case '乙':
        return WuXing.wood;
      case '丙':
      case '丁':
        return WuXing.fire;
      case '戊':
      case '己':
        return WuXing.earth;
      case '庚':
      case '辛':
        return WuXing.metal;
      case '壬':
      case '癸':
        return WuXing.water;
      default:
        throw Exception('알 수 없는 천간: $chineseSky');
    }
  }
}
