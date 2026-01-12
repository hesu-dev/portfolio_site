import 'package:http/http.dart' as http;
import '../../../core/env.dart';
import '../parser/lrsr_xml_parser.dart';
import '../model/lun_cal_item.dart';
import 'lrsr_cld_endpoints.dart';

class LrsrCldClient {
  final http.Client _http;

  LrsrCldClient({http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  Uri _buildUri(String path, Map<String, String> query) {
    final serviceKey = Env.serviceKey;
    if (serviceKey.isEmpty) {
      throw StateError('APP_SECRET_KEY is empty');
    }

    final base = Env.proxyBaseUrl.isNotEmpty
        ? Env
              .proxyBaseUrl // Worker가 실제 apis.data.go.kr로 포워딩
        : LrsrCldEndpoints.hostHttps;

    final uri = Uri.parse(base).replace(
      path: Env.proxyBaseUrl.isNotEmpty ? '/kasi' : path,
      queryParameters: {...query, 'ServiceKey': serviceKey},
    );

    // Worker 사용 시: 원래 path를 추가 파라미터로 넘겨서 서버에서 재조합
    if (Env.proxyBaseUrl.isNotEmpty) {
      return uri.replace(
        queryParameters: {...uri.queryParameters, '__path': path},
      );
    }

    return uri;
  }

  Future<LunCalItem> getLunCalInfo({
    required int solYear,
    required int solMonth,
    required int solDay,
  }) async {
    final uri = _buildUri(LrsrCldEndpoints.getLunCalInfo, {
      'solYear': solYear.toString().padLeft(4, '0'),
      'solMonth': solMonth.toString().padLeft(2, '0'),
      'solDay': solDay.toString().padLeft(2, '0'),
    });

    final res = await _http.get(uri);
    if (res.statusCode != 200) {
      throw StateError('HTTP ${res.statusCode}: ${res.body}');
    }

    return LrsrXmlParser.parseLunCalInfo(res.body);
  }
}
