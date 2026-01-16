class SolCalItem {
  final int solYear;
  final int solMonth;
  final int solDay;

  final int lunYear;
  final int lunMonth;
  final int lunDay;

  final String lunLeapmonth;
  final String lunIljin;
  final String lunSecha;
  final String lunWolgeon;
  final int solJd;

  const SolCalItem({
    required this.solYear,
    required this.solMonth,
    required this.solDay,
    required this.lunYear,
    required this.lunMonth,
    required this.lunDay,
    required this.lunLeapmonth,
    required this.lunIljin,
    required this.lunSecha,
    required this.lunWolgeon,
    required this.solJd,
  });
}
