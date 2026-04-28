import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/current_weather_model.dart';
import '../models/forecast_model.dart';

class WeatherApiService {
  // Fetch current weather by city
  Future<CurrentWeatherModel> fetchCurrentWeatherByCity(String city) async {
    final url = Uri.parse(ApiConstants.currentWeatherByCity(city));

    try {
      final response = await http.get(url);

      // Check if request was successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return CurrentWeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Fetch current weather using latitude & longitude
  Future<CurrentWeatherModel> fetchCurrentWeatherByLocation(
      double lat, double lon) async {
    final url = Uri.parse(ApiConstants.currentWeatherByLocation(lat, lon));

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return CurrentWeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load location weather');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Fetch forecast by city
  Future<List<ForecastModel>> fetchForecastByCity(String city) async {
    final url = Uri.parse(ApiConstants.forecastByCity(city));

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List list = data['list'];

        return list
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load forecast');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Fetch forecast by location
  Future<List<ForecastModel>> fetchForecastByLocation(
      double lat, double lon) async {
    final url = Uri.parse(ApiConstants.forecastByLocation(lat, lon));

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List list = data['list'];

        return list
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load forecast');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}