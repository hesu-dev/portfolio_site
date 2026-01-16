import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saju/a_delete/manses/calendar/api/lrsr_cld_client.dart';
import 'package:saju/a_delete/manses/calendar/repo/manses_calendar_repo.dart';
import 'package:saju/a_delete/manses/calendar/store/manses_memory_db.dart';

final lrsrClientProvider = Provider<LrsrCldClient>((ref) {
  return LrsrCldClient();
});

final mansesDbProvider = Provider<MansesMemoryDb>((ref) {
  return MansesMemoryDb();
});

final mansesCalendarRepoProvider = Provider<MansesCalendarRepo>((ref) {
  return MansesCalendarRepo(
    ref.read(lrsrClientProvider),
    ref.read(mansesDbProvider),
  );
});
