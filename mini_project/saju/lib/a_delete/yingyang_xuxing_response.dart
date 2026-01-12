import 'wu_xing_dto.dart';
import '../manses/wuxing/yin_yang.dart';
import 'request_type.dart';

sealed class YingYangXuXingResponse {
  const YingYangXuXingResponse();

  factory YingYangXuXingResponse.parse(
    Map<String, dynamic> json,
    RequestType type,
  ) {
    if (type == RequestType.hash) {
      final yin = (json['yinYangs'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, YinYang.fromJson(v as Map<String, dynamic>)),
      );
      final wu = (json['xuXings'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, WuXingDto.fromJson(v as Map<String, dynamic>)),
      );
      return YingYangXuXingHash(yinYangs: yin, xuXings: wu);
    } else {
      final yin = (json['yinYangs'] as List)
          .map((e) => YinYang.fromJson(e as Map<String, dynamic>))
          .toList();
      final wu = (json['xuXings'] as List)
          .map((e) => WuXingDto.fromJson(e as Map<String, dynamic>))
          .toList();
      return YingYangXuXingNormal(yinYangs: yin, xuXings: wu);
    }
  }
}

class YingYangXuXingNormal extends YingYangXuXingResponse {
  final List<YinYang> yinYangs;
  final List<WuXingDto> xuXings;
  const YingYangXuXingNormal({required this.yinYangs, required this.xuXings});
}

class YingYangXuXingHash extends YingYangXuXingResponse {
  final Map<String, YinYang> yinYangs;
  final Map<String, WuXingDto> xuXings;
  const YingYangXuXingHash({required this.yinYangs, required this.xuXings});
}
