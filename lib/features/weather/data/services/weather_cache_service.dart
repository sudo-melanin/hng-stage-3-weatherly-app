import 'package:hive/hive.dart';

import '../models/current_weather_model.dart';
import '../models/forecast_model.dart';

class WeatherCacheService {
  static const String _boxName = 'weather_cache';

  static const String _currentWeatherKey = 'current_weather';
  static const String _forecastKey = 'forecast';
  static const String _lastUpdatedKey = 'last_updated';

  final Box _box = Hive.box(_boxName);

  Future<void> saveWeatherData({
    required CurrentWeatherModel currentWeather,
    required List<ForecastModel> forecast,
  }) async {
    await _box.put(_currentWeatherKey, currentWeather.toJson());

    await _box.put(
      _forecastKey,
      forecast.map((item) => item.toJson()).toList(),
    );

    await _box.put(_lastUpdatedKey, DateTime.now().toIso8601String());
  }

  CurrentWeatherModel? getCachedCurrentWeather() {
    final data = _box.get(_currentWeatherKey);

    if (data == null) return null;

    return CurrentWeatherModel.fromCache(data);
  }

  List<ForecastModel> getCachedForecast() {
    final data = _box.get(_forecastKey);

    if (data == null) return [];

    return (data as List)
        .map((item) => ForecastModel.fromCache(item))
        .toList();
  }

  DateTime? getLastUpdatedTime() {
    final data = _box.get(_lastUpdatedKey);

    if (data == null) return null;

    return DateTime.tryParse(data);
  }

  bool hasCachedWeather() {
    return _box.containsKey(_currentWeatherKey) &&
        _box.containsKey(_forecastKey);
  }

  Future<void> clearCache() async {
    await _box.clear();
  }
}