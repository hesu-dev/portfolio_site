import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../../data/repositories/mock_weather_repository.dart';
import '../../../data/repositories/weather_repository_impl.dart';
import '../../../data/sources/remote/weather_api_service.dart';

// Repository Provider
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  // Toggle this to switch between Mock and Real data
  const bool useRealData = false; // Set to true after adding API Key

  if (useRealData) {
    return WeatherRepositoryImpl(WeatherApiService());
  } else {
    return MockWeatherRepository();
  }
});

// Weather State Provider
final weatherProvider = FutureProvider.autoDispose<WeatherModel>((ref) async {
  final repository = ref.watch(weatherRepositoryProvider);
  // 추후 위치 정보를 동적으로 받아와야 함. 현재는 "Seoul" 예시
  return repository.fetchWeather("Seoul");
});
