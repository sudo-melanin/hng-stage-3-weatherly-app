import 'package:flutter/material.dart';

import '../data/models/current_weather_model.dart';
import '../data/models/forecast_model.dart';
import '../data/services/location_service.dart';
import '../data/services/weather_api_service.dart';
import '../data/services/weather_cache_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _apiService = WeatherApiService();
  final LocationService _locationService = LocationService();
  final WeatherCacheService _cacheService = WeatherCacheService();

  CurrentWeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  DateTime? _lastUpdated;

  bool _isLoading = false;
  bool _isUsingCachedData = false;
  String? _errorMessage;

  CurrentWeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  DateTime? get lastUpdated => _lastUpdated;

  bool get isLoading => _isLoading;
  bool get isUsingCachedData => _isUsingCachedData;
  String? get errorMessage => _errorMessage;

  bool get hasWeatherData => _currentWeather != null;

  Future<void> loadWeatherByLocation() async {
    _setLoadingState();

    try {
      final position = await _locationService.getCurrentPosition();

      final currentWeather = await _apiService.fetchCurrentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      final forecast = await _apiService.fetchForecastByLocation(
        position.latitude,
        position.longitude,
      );

      await _saveFreshWeather(currentWeather, forecast);
    } catch (e) {
      await _loadCachedWeather(
        fallbackMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> searchWeatherByCity(String city) async {
    final cleanedCity = city.trim();

    if (cleanedCity.isEmpty) {
      _errorMessage = 'Please enter a city name.';
      notifyListeners();
      return;
    }

    _setLoadingState();

    try {
      final currentWeather =
          await _apiService.fetchCurrentWeatherByCity(cleanedCity);

      final forecast = await _apiService.fetchForecastByCity(cleanedCity);

      await _saveFreshWeather(currentWeather, forecast);
    } catch (e) {
      await _loadCachedWeather(
        fallbackMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> loadCachedWeatherOnStart() async {
    if (!_cacheService.hasCachedWeather()) return;

    _currentWeather = _cacheService.getCachedCurrentWeather();
    _forecast = _cacheService.getCachedForecast();
    _lastUpdated = _cacheService.getLastUpdatedTime();
    _isUsingCachedData = true;

    notifyListeners();
  }

  Future<void> _saveFreshWeather(
    CurrentWeatherModel currentWeather,
    List<ForecastModel> forecast,
  ) async {
    _currentWeather = currentWeather;
    _forecast = forecast;
    _lastUpdated = DateTime.now();

    _isLoading = false;
    _isUsingCachedData = false;
    _errorMessage = null;

    await _cacheService.saveWeatherData(
      currentWeather: currentWeather,
      forecast: forecast,
    );

    notifyListeners();
  }

  Future<void> _loadCachedWeather({required String fallbackMessage}) async {
    if (_cacheService.hasCachedWeather()) {
      _currentWeather = _cacheService.getCachedCurrentWeather();
      _forecast = _cacheService.getCachedForecast();
      _lastUpdated = _cacheService.getLastUpdatedTime();

      _isUsingCachedData = true;
      _errorMessage = '$fallbackMessage. Showing last saved weather.';
    } else {
      _errorMessage = fallbackMessage;
    }

    _isLoading = false;
    notifyListeners();
  }

  void _setLoadingState() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}