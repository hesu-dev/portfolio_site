class WeatherModel {
  final double currentTemp;
  final String condition; // e.g., 'Sunny', 'Rain', 'Cloudy'
  final String description; // e.g., 'Today is mostly clear...'
  final String location; // City Name
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final WeatherAlert? currentAlert;

  WeatherModel({
    required this.currentTemp,
    required this.condition,
    required this.description,
    required this.location,
    required this.hourly,
    required this.daily,
    this.currentAlert,
  });

  // Factory Constructor to parse from OpenWeatherMap API responses
  // Note: We'll likely need to combine Current Weather and Forecast API responses
  factory WeatherModel.fromApi({
    required Map<String, dynamic> currentData,
    required Map<String, dynamic> forecastData,
  }) {
    final currentMain = currentData['main'] ?? {};
    final currentWeatherArr = (currentData['weather'] as List?) ?? [];
    final currentWeather = currentWeatherArr.isNotEmpty ? currentWeatherArr.first : {};
    
    final temp = (currentMain['temp'] as num?)?.toDouble() ?? 0.0;
    final condition = (currentWeather['main'] as String?) ?? 'Unknown';
    final desc = (currentWeather['description'] as String?) ?? '';
    final cityName = (currentData['name'] as String?) ?? 'Unknown City';

    // Parse Hourly/Daily from 5 Day / 3 Hour Forecast
    // Note: OWM Free tier doesn't give clean "Daily" or "Hourly" (max 48h) like OneCall.
    // We have to interpolate 3-hour steps.
    final list = (forecastData['list'] as List?) ?? [];
    
    // Hourly: Take next ~8 items (24 hours = 8 * 3h)
    List<HourlyForecast> hourlies = [];
    if (list.isNotEmpty) {
      hourlies = list.take(8).map((item) => HourlyForecast.fromApi(item)).toList();
    }

    // Daily: Naive approach - pick one entry per day (e.g., noon) or aggregate
    // For simplicity, we just filter for items around 12:00 PM
    // Or just group by day.
    List<DailyForecast> dailies = [];
    final Map<String, List<dynamic>> groupedByDay = {};
    
    for (var item in list) {
      final dtTxt = (item['dt_txt'] as String?) ?? ''; // "2022-08-30 15:00:00"
      if (dtTxt.isNotEmpty) {
        final dateKey = dtTxt.split(' ')[0]; // "2022-08-30"
        groupedByDay.putIfAbsent(dateKey, () => []).add(item);
      }
    }

    // Convert groups to DailyForecast
    groupedByDay.forEach((key, items) {
      // Create DailyForecast from list of 3h items
      if (dailies.length < 7) { // Limit 7 days
         dailies.add(DailyForecast.fromGroup(items));
      }
    });

    return WeatherModel(
      currentTemp: temp,
      condition: condition,
      description: desc.isNotEmpty ? desc : "No description available",
      location: cityName,
      hourly: hourlies,
      daily: dailies,
      currentAlert: null, // Free tier doesn't support alerts easily
    );
  }
}

class HourlyForecast {
  final DateTime time;
  final double temp;
  final String condition;
  final bool isRainy;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.condition,
    required this.isRainy,
  });

  factory HourlyForecast.fromApi(Map<String, dynamic> map) {
    final dt = (map['dt'] as num?)?.toInt() ?? 0;
    final main = map['main'] ?? {};
    final weatherArr = (map['weather'] as List?) ?? [];
    final weather = weatherArr.isNotEmpty ? weatherArr.first : {};
    
    final conditionStr = (weather['main'] as String?) ?? 'Clear';
    
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(dt * 1000),
      temp: (main['temp'] as num?)?.toDouble() ?? 0.0,
      condition: conditionStr,
      isRainy: conditionStr.toLowerCase().contains('rain'),
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final bool isRainy;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.isRainy,
  });

  factory DailyForecast.fromGroup(List<dynamic> items) {
    // Find min/max temp for the day
    double minT = 1000.0;
    double maxT = -1000.0;
    String dominantCond = "Clear";
    int rainCount = 0;

    for (var item in items) {
      final main = item['main'] ?? {};
      final tempMin = (main['temp_min'] as num?)?.toDouble() ?? 0.0;
      final tempMax = (main['temp_max'] as num?)?.toDouble() ?? 0.0;
      
      if (tempMin < minT) minT = tempMin;
      if (tempMax > maxT) maxT = tempMax;

      final weatherArr = (item['weather'] as List?) ?? [];
      if (weatherArr.isNotEmpty) {
        final cond = (weatherArr.first['main'] as String?) ?? 'Clear';
        if (cond.toLowerCase().contains('rain')) {
          rainCount++;
        }
      }
    }

    // Simple dominant condition logic
    if (rainCount > 0) dominantCond = "Rain";
    
    // Date from first item
    final firstDt = (items.first['dt'] as num?)?.toInt() ?? 0;
    final dateObj = DateTime.fromMillisecondsSinceEpoch(firstDt * 1000);

    return DailyForecast(
      date: dateObj,
      maxTemp: maxT,
      minTemp: minT,
      condition: dominantCond,
      isRainy: dominantCond == "Rain",
    );
  }
}

class WeatherAlert {
  final String title;
  final String message;
  final String type; // 'rain', 'wind', 'temp'

  WeatherAlert({
    required this.title,
    required this.message,
    required this.type,
  });
}
