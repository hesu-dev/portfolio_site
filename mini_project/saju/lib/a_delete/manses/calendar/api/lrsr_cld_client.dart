import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:saju/a_delete/core/encoding/euc_kr_decoder.dart';
import 'dart:convert';
import 'package:saju/a_delete/manses/model/jul_day_item.dart';
import 'package:saju/a_delete/manses/model/sol_cal_item.dart';
import '../../../core/env.dart';
import '../parser/lrsr_xml_parser.dart';
import '../model/lun_cal_item.dart';
import 'lrsr_cld_endpoints.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js_util' as js_util;

class LrsrCldClient {
  final http.Client _http;

  LrsrCldClient({http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  /// 🔹 ServiceKey는 이미 인코딩된 값이므로 수동 append
  Uri _buildUri(String apiPath, Map<String, String> query) {
    final serviceKey = Env.serviceKey;
    if (serviceKey.isEmpty) {
      throw StateError('ServiceKey is empty');
    }

    final base = Uri.parse(LrsrCldEndpoints.hostHttps);
    final uri = base.replace(path: apiPath, queryParameters: query);

    return Uri.parse('${uri.toString()}&ServiceKey=$serviceKey');
  }

  /// 🔹 응답 디코딩 (Web: EUC-KR / Mobile: UTF-8)
  String _decodeResponse(List<int> bytes) {
    if (kIsWeb) {
      // JS TextDecoder 사용
      final decoder = js_util.callConstructor(
        js_util.getProperty(html.window, 'TextDecoder'),
        ['euc-kr'],
      );

      return js_util.callMethod(decoder, 'decode', [bytes]);
    } else {
      // 모바일/데스크톱 fallback
      return utf8.decode(bytes, allowMalformed: true);
    }
  }

  // =========================
  // 양력 정보 조회
  // =========================
  Future<SolCalItem> getSolCalInfo({
    required int lunYear,
    required int lunMonth,
    required int lunDay,
  }) async {
    final uri = _buildUri(LrsrCldEndpoints.getSolCalInfo, {
      'lunYear': lunYear.toString().padLeft(4, '0'),
      'lunMonth': lunMonth.toString().padLeft(2, '0'),
      'lunDay': lunDay.toString().padLeft(2, '0'),
    });

    print('==== KASI REQUEST ====');
    print('URL: $uri');

    final res = await _http.get(
      uri,
      headers: const {'Accept': 'application/xml'},
    );

    print('STATUS: ${res.statusCode}');

    if (res.statusCode != 200) {
      throw StateError('HTTP ${res.statusCode}: ${res.body}');
    }

    final decoded = utf8.decode(res.bodyBytes);

    print('==== XML DECODED ====');
    print(decoded);

    return LrsrXmlParser.parseSolCalInfo(decoded);
  }

  // =========================
  // 음력 정보 조회 (선택)
  // =========================
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

    final decoded = _decodeResponse(res.bodyBytes);
    return LrsrXmlParser.parseLunCalInfo(decoded);
  }

  // =========================
  // 율리우스적 조회
  // =========================
  Future<JulDayItem> getJulDayInfo(int julDay) async {
    final uri = _buildUri(LrsrCldEndpoints.getJulDayInfo, {
      'solJd': julDay.toString(),
    });

    final res = await _http.get(uri);

    if (res.statusCode != 200) {
      throw StateError('HTTP ${res.statusCode}: ${res.body}');
    }

    final decoded = _decodeResponse(res.bodyBytes);
    return LrsrXmlParser.parseJulDayInfo(decoded);
  }
}
