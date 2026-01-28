class WeatherContext {
  final int temp;
  final int feelsLike;
  final int humidity;
  final double windSpeed;
  final int clouds; // 0~100
  final double uvi;
  final double pop; // 0.0~1.0
  final double rain; // mm
  final double snow; // mm
  final int weatherId;
  final int? seaLevel;
  
  // Lists for UI compatibility
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final WeatherAlert? currentAlert;

  WeatherContext({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.clouds,
    required this.uvi,
    required this.pop,
    required this.rain,
    required this.snow,
    required this.weatherId,
    this.seaLevel,
    this.hourly = const [],
    this.daily = const [],
    this.currentAlert,
  });

  // Helper getters for compatibility with existing UI
  double get currentTemp => temp.toDouble();
  String get condition => _getConditionString(weatherId);
  String get description => ""; // One Call usually gives detailed description in 'weather' array items

  static String _getConditionString(int id) {
    if (id >= 200 && id < 300) return "Thunderstorm";
    if (id >= 300 && id < 400) return "Drizzle";
    if (id >= 500 && id < 600) return "Rain";
    if (id >= 600 && id < 700) return "Snow";
    if (id >= 700 && id < 800) return "Atmosphere"; // Mist, Smoke, etc
    if (id == 800) return "Clear";
    if (id > 800) return "Clouds";
    return "Unknown";
  }

  factory WeatherContext.from25Api({
    required Map<String, dynamic> currentData,
    required Map<String, dynamic> forecastData,
  }) {
    // Current Weather
    final main = currentData['main'] ?? {};
    final wind = currentData['wind'] ?? {};
    final clouds = currentData['clouds'] ?? {};
    final currentRain = currentData['rain'] ?? {};
    final currentSnow = currentData['snow'] ?? {};
    final weatherArr = (currentData['weather'] as List?) ?? [];
    final weather0 = weatherArr.isNotEmpty ? weatherArr.first : {};
    final wId = (weather0['id'] as int?) ?? 800;

    // Forecast List (3-hour steps)
    final list = (forecastData['list'] as List?) ?? [];
    
    // Get POP from the first forecast item (closest future)
    double firstPop = 0.0;
    if (list.isNotEmpty) {
      firstPop = (list[0]['pop'] as num?)?.toDouble() ?? 0.0;
    }

    // Parse Hourly (Next 24h = 8 items)
    // Note: 2.5 Forecast gives 3h steps, so we map them to HourlyForecast
    List<HourlyForecast> hourlies = [];
    if (list.isNotEmpty) {
      hourlies = list.take(8).map((item) => HourlyForecast.from25Api(item)).toList();
    }

    // Parse Daily (Naive aggregation)
    List<DailyForecast> dailies = [];
    final Map<String, List<dynamic>> groupedByDay = {};
    for (var item in list) {
      final dtTxt = (item['dt_txt'] as String?) ?? ''; 
      if (dtTxt.isNotEmpty) {
        final dateKey = dtTxt.split(' ')[0];
        groupedByDay.putIfAbsent(dateKey, () => []).add(item);
      }
    }
    groupedByDay.forEach((key, items) {
      if (dailies.length < 5) { // 2.5 forecast is 5 days
         dailies.add(DailyForecast.from25Group(items));
      }
    });

    return WeatherContext(
      temp: (main['temp'] as num?)?.round() ?? 0,
      feelsLike: (main['feels_like'] as num?)?.round() ?? 0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      clouds: (clouds['all'] as num?)?.toInt() ?? 0,
      uvi: 0.0, // Not available in standard 2.5 Free
      pop: firstPop,
      rain: (currentRain['1h'] as num?)?.toDouble() ?? 0.0,
      snow: (currentSnow['1h'] as num?)?.toDouble() ?? 0.0,
      weatherId: wId,
      seaLevel: (main['sea_level'] as num?)?.toInt(),
      hourly: hourlies,
      daily: dailies,
      currentAlert: null, // Not available in standard 2.5 Free
    );
  }
}

// Logic helpers
bool isThunder(int id) => id >= 200 && id < 300;
bool isRain(int id) => id >= 500 && id < 600;
bool isSnow(int id) => id >= 600 && id < 700;
bool isHeavyRain(int id, double rain) => isRain(id) && rain >= 10;
bool isHeavySnow(int id, double snow) => isSnow(id) && snow >= 5;

class HourlyForecast {
  final DateTime time;
  final double temp;
  final String condition;
  final bool isRainy;
  final int weatherId;
  final double pop;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.condition,
    required this.isRainy,
    required this.weatherId,
    required this.pop,
  });


  factory HourlyForecast.from25Api(Map<String, dynamic> map) {
    final dt = (map['dt'] as num?)?.toInt() ?? 0;
    final main = map['main'] ?? {};
    final weatherArr = (map['weather'] as List?) ?? [];
    final weather = weatherArr.isNotEmpty ? weatherArr.first : {};
    final wId = (weather['id'] as int?) ?? 800;
    final conditionStr = (weather['main'] as String?) ?? 'Clear';

    // 2.5 Forecast list item has 'pop'
    final popVal = (map['pop'] as num?)?.toDouble() ?? 0.0;

    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(dt * 1000),
      temp: (main['temp'] as num?)?.toDouble() ?? 0.0,
      condition: conditionStr,
      isRainy: conditionStr.toLowerCase().contains('rain'),
      weatherId: wId,
      pop: popVal,
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final bool isRainy;
  final int weatherId;
  final double pop;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.isRainy,
    required this.weatherId,
    required this.pop,
  });

  factory DailyForecast.from25Group(List<dynamic> items) {
    // Aggregate 3h items to find daily min/max, dominant weather, max pop
    double minT = 1000.0;
    double maxT = -1000.0;
    String dominantCond = "Clear";
    int rainCount = 0;
    double maxPop = 0.0;
    // Simple weather ID frequency map could be better, but let's take dominant by priority or simple 'rain' check
    int dominantId = 800; // Default clear

    for (var item in items) {
      final main = item['main'] ?? {};
      final tempMin = (main['temp_min'] as num?)?.toDouble() ?? 0.0;
      final tempMax = (main['temp_max'] as num?)?.toDouble() ?? 0.0;
      final popVal = (item['pop'] as num?)?.toDouble() ?? 0.0;

      if (tempMin < minT) minT = tempMin;
      if (tempMax > maxT) maxT = tempMax;
      if (popVal > maxPop) maxPop = popVal;

      final weatherArr = (item['weather'] as List?) ?? [];
      if (weatherArr.isNotEmpty) {
        final w = weatherArr.first;
        final cond = (w['main'] as String?) ?? 'Clear';
        final wId = (w['id'] as int?) ?? 800;
        
        // Primitive dominant logic: if rain/snow found, prioritize it
        if (cond.toLowerCase().contains('rain') || cond.toLowerCase().contains('snow')) {
          dominantCond = cond;
          dominantId = wId;
          rainCount++;
        }
      }
    }
    
    // If no rain/snow found (rainCount==0), take the middle item's condition or just "Clear/Clouds"
    if (rainCount == 0 && items.isNotEmpty) {
      final midItem = items[items.length ~/ 2];
      final wArr = (midItem['weather'] as List?) ?? [];
      if (wArr.isNotEmpty) {
        dominantCond = (wArr.first['main'] as String?) ?? 'Clear';
        dominantId = (wArr.first['id'] as int?) ?? 800;
      }
    }

    final firstDt = (items.first['dt'] as num?)?.toInt() ?? 0;
    final dateObj = DateTime.fromMillisecondsSinceEpoch(firstDt * 1000);

    return DailyForecast(
      date: dateObj,
      maxTemp: maxT,
      minTemp: minT,
      condition: dominantCond,
      isRainy: dominantCond.toLowerCase().contains('rain'),
      weatherId: dominantId,
      pop: maxPop,
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
