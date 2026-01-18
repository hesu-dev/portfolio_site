import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saju/core/env/app_env.dart';
import 'package:saju/domain/models/manse_request_dto.dart';

class CalendarApi {
  final http.Client _client;
  CalendarApi({http.Client? client}) : _client = client ?? http.Client();

  Future<String> fetchCalendarXml(ManseRequestDto req) async {
    if (!AppEnv.hasKey) {
      throw Exception('서비스 키가 없습니다. APP_SECRET_KEY를 확인하세요.');
    }

    print('>>>여기가 출력이 될까요?');

    // final base = AppEnv.screatBaseUrl;

    // 한국천문연: 양력->음력(=getLunCalInfo), 음력->양력(=getSolCalInfo)
    final path = (req.calendarType == CalendarType.solar)
        ? 'getLunCalInfo'
        : 'getSolCalInfo';

    final uri = Uri(
      scheme: 'http',
      host: 'apis.data.go.kr',
      path: 'B090041/openapi/service/LrsrCldInfoService/$path',
      queryParameters: {
        'solYear': req.yyyy.toString(),
        'solMonth': req.mm.toString().padLeft(2, '0'),
        'solDay': req.dd.toString().padLeft(2, '0'),
        'ServiceKey': AppEnv.ServiceKey,
      },
    );

    print('RAW KEY = ${AppEnv.ServiceKey}');
    print('ENCODED KEY = ${Uri.encodeComponent(AppEnv.ServiceKey)}');
    print('REQUEST URI = $uri');

    final resp = await _client.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('API 호출 실패: ${resp.statusCode}');
    }

    // 응답은 XML (보통 EUC-KR일 수 있어서, bytes -> utf8/latin1 등 이슈 발생 가능)
    // 여기서는 가장 흔한 케이스로 bytes를 utf8로 시도하고, 실패하면 그대로 사용.
    try {
      return utf8.decode(resp.bodyBytes);
    } catch (_) {
      return resp.body;
    }
  }
}
