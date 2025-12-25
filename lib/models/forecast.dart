class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final double tempMin;
  final double tempMax;

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.tempMin,
    required this.tempMax,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
    );
  }

  String getIconUrl() {
    return 'https://openweathermap.org/img/wn/$icon@2x.png';
  }

  String getDayName() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dateTime.weekday - 1];
  }

  String getTime() {
    final hour = dateTime.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour $period';
  }
}

class Forecast {
  final List<ForecastItem> items;

  Forecast({required this.items});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'] ?? [];
    final items = list.map((item) => ForecastItem.fromJson(item)).toList();
    return Forecast(items: items);
  }

  // Get daily forecasts (one per day at noon)
  List<ForecastItem> getDailyForecasts() {
    final Map<String, ForecastItem> dailyMap = {};
    
    for (var item in items) {
      final dateKey = '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      
      // Prefer noon forecasts
      if (!dailyMap.containsKey(dateKey) || item.dateTime.hour == 12) {
        dailyMap[dateKey] = item;
      }
    }
    
    return dailyMap.values.toList().take(5).toList();
  }
}