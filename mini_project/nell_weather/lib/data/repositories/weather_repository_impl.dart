import '../models/weather_model.dart';
import '../sources/remote/weather_api_service.dart';
import 'weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService _apiService;

  WeatherRepositoryImpl(this._apiService);

  @override
  Future<WeatherModel> fetchWeather(String location) async {
    try {
      // Fetch data in parallel for efficiency
      final results = await Future.wait([
        _apiService.getCurrentWeather(location),
        _apiService.getForecast(location),
      ]);

      final currentData = results[0];
      final forecastData = results[1];

      return WeatherModel.fromApi(
        currentData: currentData,
        forecastData: forecastData,
      );
    } catch (e) {
      // Re-throw or handle error suitable for the UI
      throw Exception("Repository Error: $e");
    }
  }
}
