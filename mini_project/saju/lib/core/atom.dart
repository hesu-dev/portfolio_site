import 'package:saju/manses/wuxing/wu_xing.dart';

import 'base_enum.dart';
import '../manses/wuxing/yin_yang.dart';

abstract class Atom extends BaseEnum {
  YinYang? get yinYang;
  WuXing? get wuXing;
}
