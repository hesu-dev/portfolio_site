import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/domain/enums/wu_xing.dart';
import 'package:saju/domain/models/animal_title.dart';
import 'package:saju/domain/models/pillar_dto.dart';
import 'package:saju/presentation/sheets/animal_info_sheet.dart';
import 'package:saju/presentation/sheets/sheet.dart';
import 'package:saju/presentation/widgets/result/input_summary_view.dart';
import 'package:saju/presentation/widgets/result/pillar_table_view.dart';
import 'package:saju/presentation/widgets/result/wuxing_chart_view.dart';
import 'package:saju/presentation/widgets/result/wuxing_table_view.dart';
import 'package:saju/presentation/widgets/result/yin_yang_painter.dart';
import 'package:saju/providers/manse_form_provider.dart';

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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section(_profileHeader(animalTitle, context)),
                _section(PillarTableView(result: result)),
                _section(_wuxingSection(wuxingDist, yinYang)),
                _section(yongshinWidget(wuxingDist, context)),
                // _section(_yinYangSection(yinYang)),
              ],
            ),
          ),
        ),
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
  Widget _profileHeader(AnimalTitle animalTitle, BuildContext context) {
    final form = context.watch<ManseFormProvider>();
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 28, child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${form.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      // '${animalTitle.korean}(${animalTitle.chinese})'
                      '(${result.pillars.day.sky}${result.pillars.day.ground}/${animalTitle.koreanHanja})의 당신은..',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    IconButton(
                      icon: const Icon(Icons.help_outline),
                      onPressed: () => AnimalInfoSheet(),
                    ),
                  ],
                ),

                // Text(
                //   animalTitle.meaning,
                //   style: const TextStyle(color: Colors.black54, fontSize: 10),
                // ),
              ],
            ),
          ],
        ),
        _inputSummary(),
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
      time: result.timeInput,
      adjusted: result.solarDate, // 예: 지역시 -32분
    );
  }

  // =========================
  // 3. 오행 분포
  // =========================
  Widget _wuxingSection(WuXingDistribution dist, YinYangBalance b) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '오행 분포',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Center(
              child: WuXingDonutChart(
                percent: dist.percent,
                centerLabel: _dominantWuXing(dist.percent),
              ),
            ),
            const SizedBox(width: 30),
            Center(
              child: YinYangCircle(
                balance: YinYangBalance(
                  yin: b.yinPercent.toInt(),
                  yang: b.yangPercent.toInt(),
                  yinPercent: b.yinPercent,
                  yangPercent: b.yangPercent,
                  judgment: b.judgment,
                ),
                // yin: b.yinPercent.toDouble() ?? 0,
                // yang: b.yinPercent,
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WuXingTableView(percent: dist.percent),
            const SizedBox(width: 20),
            WuXingTableView(percent: dist.percent),
          ],
        ),
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

  // =========================
  // 5. 용신
  // =========================

  Widget yongshinWidget(WuXingDistribution dist, BuildContext context) {
    WuXing maxWuXing = dist.percent.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    WuXing minWuXing = dist.percent.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;

    final eokBu = getEokBuYongShin(maxWuXing);
    final joHu = getJoHuYongShin(minWuXing);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '용신',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEDEDED),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, size: 18, color: Colors.black54),
                onPressed: () {
                  showYongshinInfo(context);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ===== 용신 박스 =====
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDDDDDD), width: 1.2),
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black87),
              children: [
                TextSpan(
                  text: eokBu.display,
                  style: TextStyle(
                    color: eokBu.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '(조후용신)  ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                TextSpan(text: ' |  '),
                TextSpan(
                  text: joHu?.display,
                  style: TextStyle(
                    color: eokBu.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '(억부용신)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
