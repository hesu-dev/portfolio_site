// import '../a_delete/http_client.dart';
// import '../a_delete/api_result.dart';

// class MansesApi {
//   final SimpleHttpClient _http;
//   MansesApi(this._http);

//   Future<ApiResult<YingYangXuXingResponse>> getBase({
//     required RequestType type,
//   }) async {
//     final uri = _http.uri('/v1/manses/base', {'type': type.query});
//     final json = await _http.getJson(uri);

//     // 1) ApiResponse 래퍼가 있는 경우: { success, data }
//     if (json.containsKey('data')) {
//       final success = (json['success'] as bool?) ?? true;
//       final dataJson = json['data'] as Map<String, dynamic>;
//       final parsed = YingYangXuXingResponse.parse(dataJson, type);
//       return ApiResult(success: success, data: parsed);
//     }

//     // 2) 래퍼가 없는 기존 형태: { yinYangs, xuXings }
//     final parsed = YingYangXuXingResponse.parse(json, type);
//     return ApiResult(success: true, data: parsed);
//   }
// }
