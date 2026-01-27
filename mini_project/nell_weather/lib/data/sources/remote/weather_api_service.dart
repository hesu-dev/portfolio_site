import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApiService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.openweathermap.org/data/2.5";

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API Key not found in .env");
      }

      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric', // Use Celsius
        },
      );
      
      return response.data;
    } catch (e) {
      throw Exception("Failed to load current weather: $e");
    }
  }

  Future<Map<String, dynamic>> getForecast(String city) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API Key not found in .env");
      }

      final response = await _dio.get(
        '$_baseUrl/forecast',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
        },
      );
      
      return response.data;
    } catch (e) {
      throw Exception("Failed to load forecast: $e");
    }
  }
}
