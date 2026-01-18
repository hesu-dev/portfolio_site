import 'package:flutter/material.dart';

import '../data/clients/kari_calendar_api.dart';
import '../data/repositories/manse_repository.dart';
import '../domain/models/manse_request_dto.dart';
import '../domain/models/manse_result_dto.dart';
import '../domain/services/manse_calculator.dart';
import '../domain/services/time_ground_service.dart';
import '../domain/services/time_pillar_service.dart';

class ManseResultProvider extends ChangeNotifier {
  bool loading = true;
  ManseResultDto? result;
  String? error;

  late final ManseRepository _repo;

  ManseResultProvider() {
    // 기존 MansePage initState 에 있던 DI 그대로 옮김
    final groundService = TimeGroundService();
    final timePillarService = TimePillarService(groundService);
    final calculator = ManseCalculator(timePillarService);

    _repo = ManseRepository(api: CalendarApi(), calculator: calculator);
  }

  Future<void> load(ManseRequestDto req) async {
    loading = true;
    notifyListeners();

    try {
      result = await _repo.getManse(req);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
