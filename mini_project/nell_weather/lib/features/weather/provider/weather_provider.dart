import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../../data/repositories/mock_weather_repository.dart';
import '../../../data/repositories/weather_repository_impl.dart';
import '../../../data/sources/remote/weather_api_service.dart';
import '../../settings/provider/settings_provider.dart';

// Repository Provider
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  // Toggle this to switch between Mock and Real data
  const bool useRealData =
      false; // Set to true after API Key is ready and tested

  if (useRealData) {
    return WeatherRepositoryImpl(WeatherApiService());
  } else {
    return MockWeatherRepository();
  }
});

// Weather State Provider
final weatherProvider = FutureProvider.autoDispose<WeatherContext>((ref) async {
  final repository = ref.watch(weatherRepositoryProvider);
  final settings = ref.watch(settingsProvider);

  // 1. Check for active Custom Location
  final activeLocation = settings.customLocations.firstWhere(
    (loc) => loc.isActive,
    orElse: () =>
        CustomLocation(id: '', name: '', lat: 0, lng: 0, isActive: false),
  );

  if (activeLocation.isActive) {
    // Use Custom Location
    return repository.fetchWeatherByCoordinates(
      activeLocation.lat,
      activeLocation.lng,
    );
  } else {
    // 2. Use Current Device Location (GPS)
    try {
      final position = await _determinePosition();
      return repository.fetchWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      // Fallback if permission denied or error
      // TODO: Show error or fallback to default city
      // ignore: avoid_print
      print("Error fetching weather by location: $e. Fallback to Seoul.");
      return repository.fetchWeather("Seoul");
    }
  }
});

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  return await Geolocator.getCurrentPosition(
    timeLimit: const Duration(seconds: 5),
  );
}
