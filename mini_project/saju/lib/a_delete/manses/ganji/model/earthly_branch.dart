/// 지지(地支) 12개
enum EarthlyBranch { ja, chuk, in_, myo, jin, sa, o, mi, sin, yu, sul, hae }

extension EarthlyBranchKorean on EarthlyBranch {
  String get korean {
    switch (this) {
      case EarthlyBranch.ja:
        return '자';
      case EarthlyBranch.chuk:
        return '축';
      case EarthlyBranch.in_:
        return '인';
      case EarthlyBranch.myo:
        return '묘';
      case EarthlyBranch.jin:
        return '진';
      case EarthlyBranch.sa:
        return '사';
      case EarthlyBranch.o:
        return '오';
      case EarthlyBranch.mi:
        return '미';
      case EarthlyBranch.sin:
        return '신';
      case EarthlyBranch.yu:
        return '유';
      case EarthlyBranch.sul:
        return '술';
      case EarthlyBranch.hae:
        return '해';
    }
  }
}
