import 'package:saju/a_delete/manses/calendar/model/lun_cal_item.dart';
import 'package:saju/a_delete/manses/model/jul_day_item.dart';
import 'package:saju/a_delete/manses/model/sol_cal_item.dart';

class CalendarResult {
  final DateTime solar;
  final SolCalItem? solCal;
  final JulDayItem julDay;
  final LunCalItem? lunCal;

  CalendarResult({
    required this.solar,
    required this.solCal,
    required this.julDay,
    required this.lunCal,
  });
}
