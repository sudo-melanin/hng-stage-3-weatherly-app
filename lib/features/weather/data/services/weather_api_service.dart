import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/current_weather_model.dart';
import '../models/forecast_model.dart';

class WeatherApiService {
  Future<CurrentWeatherModel> fetchCurrentWeatherByCity(String city) async {
    final url = Uri.parse(ApiConstants.currentWeatherByCity(city));

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CurrentWeatherModel.fromJson(data);
      }

      _handleStatusCode(response.statusCode);
    } catch (e) {
      _handleException(e);
    }

  }

  Future<CurrentWeatherModel> fetchCurrentWeatherByLocation(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(ApiConstants.currentWeatherByLocation(lat, lon));

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CurrentWeatherModel.fromJson(data);
      }

      _handleStatusCode(response.statusCode);
    } catch (e) {
      _handleException(e);
    }

  }

  Future<List<ForecastModel>> fetchForecastByCity(String city) async {
    final url = Uri.parse(ApiConstants.forecastByCity(city));

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['list'];

        return list.map((item) => ForecastModel.fromJson(item)).toList();
      }

      _handleStatusCode(response.statusCode);
    } catch (e) {
      _handleException(e);
    }

  }

  Future<List<ForecastModel>> fetchForecastByLocation(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(ApiConstants.forecastByLocation(lat, lon));

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['list'];

        return list.map((item) => ForecastModel.fromJson(item)).toList();
      }

      _handleStatusCode(response.statusCode);
    } catch (e) {
      _handleException(e);
    }

  }

  Never _handleStatusCode(int statusCode) {
    if (statusCode == 404) {
      throw Exception('City not found. Please check the spelling and try again.');
    }

    if (statusCode == 401) {
      throw Exception('Weather service setup issue. Please try again later.');
    }

    if (statusCode == 429) {
      throw Exception('Weather service is busy right now. Please try again later.');
    }

    throw Exception('Unable to fetch weather data. Please try again.');
  }

  Never _handleException(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');

    final safeMessages = [
      'City not found. Please check the spelling and try again.',
      'Weather service setup issue. Please try again later.',
      'Weather service is busy right now. Please try again later.',
      'Unable to fetch weather data. Please try again.',
    ];

    if (safeMessages.contains(message)) {
      throw Exception(message);
    }

    throw Exception('Unable to connect. Please check your internet connection.');
  }
}