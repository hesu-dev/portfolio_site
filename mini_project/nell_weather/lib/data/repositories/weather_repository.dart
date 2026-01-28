import '../models/weather_model.dart';

abstract class WeatherRepository {
  Future<WeatherContext> fetchWeather(String location);
  Future<WeatherContext> fetchWeatherByCoordinates(double lat, double lon);
}
