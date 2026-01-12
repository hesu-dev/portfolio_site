import 'dart:convert';
import 'package:http/http.dart' as http;

class SimpleHttpClient {
  final String baseUrl;
  final http.Client _client;

  SimpleHttpClient({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  Uri uri(String path, [Map<String, String>? query]) {
    final normalizedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '$normalizedBase$normalizedPath',
    ).replace(queryParameters: query);
  }

  Future<Map<String, dynamic>> getJson(Uri uri) async {
    final res = await _client.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw Exception('Invalid JSON root: expected object');
  }
}
