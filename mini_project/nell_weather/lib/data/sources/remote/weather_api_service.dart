import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApiService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
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

  Future<Map<String, dynamic>> getCurrentWeatherByCoordinates(double lat, double lon) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API Key not found in .env");
      }

      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
        },
      );
      
      return response.data;
    } catch (e) {
      throw Exception("Failed to load weather by coordinates: $e");
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

  Future<Map<String, dynamic>> getForecastByCoordinates(double lat, double lon) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API Key not found in .env");
      }

      final response = await _dio.get(
        '$_baseUrl/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
        },
      );
      
      return response.data;
    } catch (e) {
      throw Exception("Failed to load forecast by coordinates: $e");
    }
  }
  Future<Map<String, dynamic>> getOneCallWeather(double lat, double lon) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API Key not found in .env");
      }

      // One Call 3.0 API
      // https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
      final response = await _dio.get(
        'https://api.openweathermap.org/data/3.0/onecall',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
          // 'exclude': 'minutely', // user might want rain/snow 1h from minutely? No, usually in current/hourly.
        },
      );
      
      return response.data;
    } catch (e) {
      throw Exception("Failed to load One Call weather: $e");
    }
  }

  Future<Map<String, double>> getCoordinatesByCityName(String city) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API Key not found in .env");
      }

      // Geocoding API
      // http://api.openweathermap.org/geo/1.0/direct?q={city name}&limit=1&appid={API key}
      final response = await _dio.get(
        'https://api.openweathermap.org/geo/1.0/direct',
        queryParameters: {
          'q': city,
          'limit': 1,
          'appid': apiKey,
        },
      );
      
      final List data = response.data;
      if (data.isNotEmpty) {
        return {
          'lat': (data[0]['lat'] as num).toDouble(),
          'lon': (data[0]['lon'] as num).toDouble(),
        };
      } else {
        throw Exception("City not found");
      }
    } catch (e) {
      throw Exception("Failed to get coordinates: $e");
    }
  }
}
