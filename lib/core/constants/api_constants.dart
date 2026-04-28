import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  static const String weatherIconBaseUrl = 'https://openweathermap.org/img/wn';

  static String currentWeatherByCity(String city) {
    return '$baseUrl/weather?q=$city&appid=$apiKey&units=metric';
  }

  static String currentWeatherByLocation(double lat, double lon) {
    return '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
  }

  static String forecastByCity(String city) {
    return '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric';
  }

  static String forecastByLocation(double lat, double lon) {
    return '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
  }

  static String weatherIconUrl(String iconCode) {
    return '$weatherIconBaseUrl/$iconCode@2x.png';
  }
}