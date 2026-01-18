class FortunePreview {
  final String note;
  final String daeun;
  final String saeun;
  final String yongshin;

  FortunePreview(this.note, this.daeun, this.saeun, this.yongshin);
}

class FortunePreviewService {
  FortunePreview preview() {
    return FortunePreview(
      '※ 절입시간 미적용, 참고용 해석',
      '대운은 월주 기준 10년 단위로 흘러갑니다.',
      '세운은 해당 연도의 천간지지 영향을 받습니다.',
      '용신/희신은 오행 분포와 계절 판단이 필요합니다.',
    );
  }
}
