class TenGodsSummary {
  final Map<String, int> counts;
  final String summary;

  TenGodsSummary(this.counts, this.summary);
}

class TenGodsSummaryService {
  TenGodsSummary analyze(List<String> bloodList) {
    final map = <String, int>{};
    for (final b in bloodList) {
      map[b] = (map[b] ?? 0) + 1;
    }

    final dominant = map.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    final summary = switch (dominant) {
      '식신' || '상관' => '표현력·창작 성향이 강함',
      '정재' || '편재' => '현실 감각·경제 활동 중시',
      '정관' || '편관' => '책임감·규범 의식 강함',
      '정인' || '편인' => '학습·사유 성향',
      _ => '균형형 성향',
    };

    return TenGodsSummary(map, summary);
  }
}
