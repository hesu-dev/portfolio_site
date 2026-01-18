import 'package:flutter/material.dart';
import 'package:saju/domain/enums/wu_xing.dart';
import 'package:saju/domain/models/animal_title.dart';
import 'package:saju/presentation/widgets/result/input_summary_view.dart';
import 'package:saju/presentation/widgets/result/pillar_table_view.dart';
import 'package:saju/presentation/widgets/result/wuxing_chart_view.dart';
import 'package:saju/presentation/widgets/result/wuxing_table_view.dart';

import '../../domain/models/manse_result_dto.dart';
import '../../domain/services/wuxing_distribution_service.dart';
import '../../domain/services/yin_yang_balance_service.dart';
import '../../domain/services/animal_title_service.dart';

class ResultPanel extends StatelessWidget {
  final ManseResultDto result;

  const ResultPanel({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    // ===== 분석 서비스 =====
    final wuxingDist = WuXingDistributionService().analyze(result);

    final skies = [
      result.pillars.year.sky,
      result.pillars.month.sky,
      result.pillars.day.sky,
      result.pillars.time.sky,
    ];
    final yinYang = YinYangBalanceService().analyze(skies);

    final animalTitle = AnimalTitleService().resolve(
      result.pillars.day.skyEnum,
      result.pillars.day.groundEnum,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section(_profileHeader(animalTitle)),
          _section(_inputSummary()),
          _section(PillarTableView(result: result)),
          _section(_wuxingSection(wuxingDist)),
          _section(_yinYangSection(yinYang)),
        ],
      ),
    );
  }

  // =========================
  // 섹션 래퍼
  // =========================
  Widget _section(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 1,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }

  // =========================
  // 1. 프로필 + 별칭
  // =========================
  Widget _profileHeader(AnimalTitle animalTitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(radius: 28, child: Icon(Icons.person)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${animalTitle.korean}(${animalTitle.chinese})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${animalTitle.koreanHanja}의 당신은..\n${animalTitle.meaning}',
              style: const TextStyle(color: Colors.black54),
            ),

            Text(
              '${result.pillars.day.sky}${result.pillars.day.ground}',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // 2. 입력 날짜 요약
  // =========================
  Widget _inputSummary() {
    return InputSummaryView(
      solar: result.solarDate, // 예: 2022/11/11 19:00
      lunar: result.solarDate, // 예: 2022/10/18 19:00 (평)
      adjusted: result.solarDate, // 예: 지역시 -32분
    );
  }

  // =========================
  // 3. 오행 분포
  // =========================
  Widget _wuxingSection(WuXingDistribution dist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '오행 분포',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Center(
          child: WuXingDonutChart(
            percent: dist.percent,
            centerLabel: _dominantWuXing(dist.percent),
          ),
        ),
        const SizedBox(height: 16),
        WuXingTableView(percent: dist.percent),
      ],
    );
  }

  String _dominantWuXing(Map<WuXing, double> percent) {
    final e = percent.entries.reduce((a, b) => a.value > b.value ? a : b);

    return '${e.key.korean}${e.key.chinese}';
  }

  // =========================
  // 4. 음양 균형
  // =========================
  Widget _yinYangSection(YinYangBalance b) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '음양 균형',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          '양 ${b.yangPercent.toStringAsFixed(0)}% / '
          '음 ${b.yinPercent.toStringAsFixed(0)}%',
        ),
        const SizedBox(height: 4),
        Text(
          '판정: ${b.judgment}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
