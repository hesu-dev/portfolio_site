import '../models/weather_model.dart';
import 'weather_repository.dart';

class MockWeatherRepository implements WeatherRepository {
  @override
  Future<WeatherContext> fetchWeather(String location) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Dummy Data
    return _getDummyData(location);
  }

  @override
  Future<WeatherContext> fetchWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return _getDummyData("Custom Location ($lat, $lon)");
  }

  WeatherContext _getDummyData(String locationName) {
    return WeatherContext(
      temp: 22,
      feelsLike: 23,
      humidity: 60,
      windSpeed: 3.5,
      clouds: 20,
      uvi: 5.0,
      pop: 0.1,
      rain: 0.0,
      snow: 0.0,
      weatherId: 999, // Clear
      // lists
      hourly: List.generate(12, (index) {
        final time = DateTime.now().add(Duration(hours: index));
        final isRain = index == 3 || index == 4;
        return HourlyForecast(
          time: time,
          temp: 22.0 - index,
          condition: isRain ? "Rain" : "Sunny",
          isRainy: isRain,
          weatherId: isRain ? 500 : 800,
          pop: isRain ? 0.8 : 0.0,
        );
      }),
      daily: List.generate(7, (index) {
        final date = DateTime.now().add(Duration(days: index));
        final isRain = index == 2;
        return DailyForecast(
          date: date,
          maxTemp: 24.0 - index,
          minTemp: 15.0 - index,
          condition: isRain ? "Rain" : "Sunny",
          isRainy: isRain,
          weatherId: isRain ? 500 : 800,
          pop: isRain ? 0.6 : 0.0,
        );
      }),
    );
  }
}
