import '../models/weather_model.dart';
import 'weather_repository.dart';

class MockWeatherRepository implements WeatherRepository {
  @override
  Future<WeatherModel> fetchWeather(String location) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Dummy Data
    return WeatherModel(
      location: "San Francisco",
      currentTemp: 22.0,
      condition: "Sunny",
      description: "Today is mostly clear, but keep an umbrella ready for the evening.",
      currentAlert: WeatherAlert(
        title: "NEXT CHANGE",
        message: "Rain expected at 18:00",
        type: "rain",
      ),
      hourly: List.generate(12, (index) {
        final time = DateTime.now().add(Duration(hours: index));
        final isRain = index == 3 || index == 4;
        return HourlyForecast(
          time: time,
          temp: 22.0 - index,
          condition: isRain ? "Rain" : "Sunny",
          isRainy: isRain,
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
        );
      }),
    );
  }
}
