import 'package:saju/a_delete/wu_xing_dto.dart';
import 'package:saju/manses/wuxing/wu_xing.dart';

import '../wuxing/yin_yang.dart';

class Sky {
  final int idx;
  final String korean;
  final String chinese;
  final WuXingDto wuXing;
  final YinYang yinYang;

  Sky({
    required this.idx,
    required this.korean,
    required this.chinese,
    required this.wuXing,
    required this.yinYang,
  });

  factory Sky.fromJson(Map<String, dynamic> json) {
    return Sky(
      idx: (json['idx'] as num).toInt(),
      korean: json['korean'] as String,
      chinese: json['chinese'] as String,
      wuXing: WuXingDto.fromJson(json['wuXing'] as Map<String, dynamic>),
      yinYang: YinYang.fromJson(json['yinYang'] as Map<String, dynamic>),
    );
  }
}
