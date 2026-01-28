import '../models/weather_model.dart';
import '../sources/remote/weather_api_service.dart';
import 'weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService _apiService;

  WeatherRepositoryImpl(this._apiService);


  @override
  Future<WeatherContext> fetchWeather(String location) async {
    try {
      // 2.5 API requires fetching Current and Forecast separately
      final results = await Future.wait([
        _apiService.getCurrentWeather(location),
        _apiService.getForecast(location),
      ]);

      return WeatherContext.from25Api(
        currentData: results[0],
        forecastData: results[1],
      );
    } catch (e) {
      throw Exception("Repository Error: $e");
    }
  }

  @override
  Future<WeatherContext> fetchWeatherByCoordinates(double lat, double lon) async {
    try {
      final results = await Future.wait([
        _apiService.getCurrentWeatherByCoordinates(lat, lon),
        _apiService.getForecastByCoordinates(lat, lon),
      ]);

      return WeatherContext.from25Api(
        currentData: results[0],
        forecastData: results[1],
      );
    } catch (e) {
      throw Exception("Repository (Coordinates) Error: $e");
    }
  }
}
