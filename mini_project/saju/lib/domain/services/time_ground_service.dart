import '../enums/ground.dart';
import '../models/time_ground_result.dart';

class TimeGroundService {
  static const int _base = 23 * 60 + 30; // 23:30

  /// 분 단위 index 계산 + 자시 첫째 시(23:30~00:30) 플래그 포함
  TimeGroundResult find(int hour, int minute) {
    final minutes = hour * 60 + minute; // 0..1439

    // 자시 첫째 시: 23:30..23:59 또는 00:00..00:29
    final isEarlyZi = (minutes >= _base) || (minutes < 30);

    // 00:00..23:29는 다음날로 붙여서 같은 축에서 계산
    final adjusted = (minutes < _base) ? minutes + 1440 : minutes;

    final idx0to11 = ((adjusted - _base) ~/ 120) % 12;
    return TimeGroundResult(Ground.values[idx0to11], isEarlyZi);
  }
}
