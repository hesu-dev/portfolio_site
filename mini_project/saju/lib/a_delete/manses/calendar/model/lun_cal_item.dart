class LunCalItem {
  final int solYear;
  final int solMonth;
  final int solDay;

  final int lunYear;
  final int lunMonth;
  final int lunDay;

  final String lunLeapmonth; // 평/윤
  final String solLeapyear; // 평/윤
  final String solWeek; // 요일(한글)
  final String lunSecha; // 세차(간지)
  final String lunWolgeon; // 월건(간지)
  final String lunIljin; // 일진(간지)
  final int lunNday; // 음력 월 일수
  final int solJd; // 율리우스적일

  const LunCalItem({
    required this.solYear,
    required this.solMonth,
    required this.solDay,
    required this.lunYear,
    required this.lunMonth,
    required this.lunDay,
    required this.lunLeapmonth,
    required this.solLeapyear,
    required this.solWeek,
    required this.lunSecha,
    required this.lunWolgeon,
    required this.lunIljin,
    required this.lunNday,
    required this.solJd,
  });
}
