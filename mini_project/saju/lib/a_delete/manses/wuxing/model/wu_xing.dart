enum WuXing { wood, fire, earth, metal, water }

extension WuXingKorean on WuXing {
  String get korean {
    switch (this) {
      case WuXing.wood:
        return '목';
      case WuXing.fire:
        return '화';
      case WuXing.earth:
        return '토';
      case WuXing.metal:
        return '금';
      case WuXing.water:
        return '수';
    }
  }
}
