import 'wu_xing_dto.dart';

class JiJangGan {
  final JiJangGanItem? first;
  final JiJangGanItem? second;
  final JiJangGanItem? third;

  JiJangGan({this.first, this.second, this.third});

  factory JiJangGan.fromJson(Map<String, dynamic> json) {
    JiJangGanItem? parseItem(dynamic v) {
      if (v == null) return null;
      return JiJangGanItem.fromJson(v as Map<String, dynamic>);
    }

    return JiJangGan(
      first: parseItem(json['first']),
      second: parseItem(json['second']),
      third: parseItem(json['third']),
    );
  }
}

class JiJangGanItem {
  final double rate;
  final String korean;
  final String chinese;
  final WuXingDto wuXing;

  JiJangGanItem({
    required this.rate,
    required this.korean,
    required this.chinese,
    required this.wuXing,
  });

  factory JiJangGanItem.fromJson(Map<String, dynamic> json) {
    return JiJangGanItem(
      rate: (json['rate'] as num).toDouble(),
      korean: json['korean'] as String,
      chinese: json['chinese'] as String,
      wuXing: WuXingDto.fromJson(json['wuXing'] as Map<String, dynamic>),
    );
  }
}
