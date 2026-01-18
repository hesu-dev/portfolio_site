import '../enums/sky.dart';
import '../models/pillar_dto.dart';
import 'time_ground_service.dart';

class TimePillarService {
  final TimeGroundService _timeGroundService;

  TimePillarService(this._timeGroundService);

  /// 조견표 수식:
  /// start = ((daySkyIdx-1) % 5) * 2 + 1
  /// timeSkyIdx = start + (groundIndex-1) -> 10순환
  TimePillarDto calculate({
    required Sky daySky,
    required int hour,
    required int minute,
  }) {
    final tg = _timeGroundService.find(hour, minute);
    final g = tg.ground.index1to12;

    final startSkyIdx = ((daySky.idx - 1) % 5) * 2 + 1; // 1,3,5,7,9
    final raw = startSkyIdx + (g - 1);
    final idx1to10 = ((raw - 1) % 10) + 1;

    final sky = Sky.fromIdx(idx1to10);
    return TimePillarDto(
      sky: sky.chinese,
      ground: tg.ground.chinese,
      isEarlyZi: tg.isEarlyZi,
      skyEnum: sky,
      groundEnum: tg.ground,
    );
  }
}
