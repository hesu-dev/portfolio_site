import '../api/lrsr_cld_client.dart';
import '../model/lun_cal_item.dart';
import '../store/manses_memory_db.dart';

class MansesCalendarRepo {
  final LrsrCldClient _client;
  final MansesMemoryDb _db;

  MansesCalendarRepo(this._client, this._db);

  Future<LunCalItem> getLunBySolar(DateTime solar) async {
    final y = solar.year, m = solar.month, d = solar.day;
    final cached = _db.getLun(y, m, d);
    if (cached != null) return cached;

    final fetched = await _client.getLunCalInfo(
      solYear: y,
      solMonth: m,
      solDay: d,
    );
    _db.putLun(fetched);
    return fetched;
  }
}
