import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/juso_model.dart';

class JusoApiService {
  final Dio _dio = Dio();
  // 행안부 주소 검색 API (OpenAPI)
  final String _baseUrl = "https://business.juso.go.kr/addrlink/addrLinkApi.do";

  Future<List<JusoModel>> searchAddress(String keyword, {int page = 1, int limit = 10}) async {
    try {
      final apiKey = dotenv.env['JUSO_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("JUSO_API_KEY not found in .env");
      }

      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'confmKey': apiKey,
          'currentPage': page,
          'countPerPage': limit,
          'keyword': keyword,
          'resultType': 'json',
        },
      );
      
      // 행안부 API는 JSON을 String으로 주지 않고 바로 Map으로 주는지, 
      // 아니면 String으로 주는지 확인 필요하지만 Dio는 Content-Type에 따라 자동 파싱함.
      // 만약 200 OK라도 에러 메시지가 있을 수 있음 (JusoResponse에서 처리)
      
      final data = JusoResponse.fromJson(response.data);
      if (data.errorMessage.isNotEmpty) {
        throw Exception(data.errorMessage);
      }

      return data.jusoList;
    } catch (e) {
      throw Exception("Address Search Error: $e");
    }
  }
}
