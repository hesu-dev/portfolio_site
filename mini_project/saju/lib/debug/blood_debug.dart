// import '../manses/core/base_enum.dart';
// import '../manses/manses/blood/blood_relation.dart';
// import '../manses/manses/ganji/ganji.dart';

// void runBloodDebug(List<GanJi> samples) {
//   final relation = BloodRelation();

//   void printLine(GanJi from, GanJi to) {
//     final fromStr = BaseEnum.getMultiLang(from, true);
//     final fromWu = BaseEnum.getMultiLang(from.wuXing!, false);

//     final toStr = BaseEnum.getMultiLang(to, true);
//     final toWu = BaseEnum.getMultiLang(to.wuXing!, false);

//     final blood = relation.analyze(from, to);
//     final bloodStr = blood == null ? '(분석불가)' : BaseEnum.getMultiLang(blood, true);

//     print('$fromStr$fromWu 일간에게 $toStr$toWu 는 $bloodStr 에 해당');
//   }

//   // samples[0]을 일간으로 두고 비교
//   final dayMaster = samples.first;
//   for (var i = 1; i < samples.length; i++) {
//     printLine(dayMaster, samples[i]);
//   }
// }
