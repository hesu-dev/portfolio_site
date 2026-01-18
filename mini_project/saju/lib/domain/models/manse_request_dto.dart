import '../../core/utils/date_time_utils.dart';

enum CalendarType { solar, lunar }

class ManseRequestDto {
  final CalendarType calendarType;
  final DateTime date; // 로컬 날짜
  final int hour;
  final int minute;
  final bool isLeapMonth; // 음력일 때만 의미

  const ManseRequestDto({
    required this.calendarType,
    required this.date,
    required this.hour,
    required this.minute,
    required this.isLeapMonth,
  });

  String get hhmm => hm(hour, minute);
  String get yyyy => date.year.toString().padLeft(4, '0');
  String get mm => two(date.month);
  String get dd => two(date.day);
}
