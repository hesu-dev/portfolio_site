import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../http_client.dart';
import '../request_type.dart';
import '../../manses/manses_api.dart';
import '../yingyang_xuxing_response.dart';
import '../api_result.dart';

final httpClientProvider = Provider<SimpleHttpClient>((ref) {
  // TODO: 네 백엔드 주소로 바꾸세요 (예: http://localhost:8080)
  return SimpleHttpClient(
    baseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    ),
  );
});

final mansesApiProvider = Provider<MansesApi>((ref) {
  return MansesApi(ref.watch(httpClientProvider));
});

final requestTypeProvider = StateProvider<RequestType>(
  (ref) => RequestType.normal,
);

final mansesBaseProvider = FutureProvider<ApiResult<YingYangXuXingResponse>>((
  ref,
) async {
  final api = ref.watch(mansesApiProvider);
  final type = ref.watch(requestTypeProvider);
  return api.getBase(type: type);
});
