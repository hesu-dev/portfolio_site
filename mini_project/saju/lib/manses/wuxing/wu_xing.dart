import '../../core/base_enum.dart';

enum WuXing implements BaseEnum {
  wood('목', '木'),
  fire('화', '火'),
  earth('토', '土'),
  metal('금', '金'),
  water('수', '水');

  @override
  final String korean;
  @override
  final String chinese;

  const WuXing(this.korean, this.chinese);
}
