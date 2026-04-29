import 'package:flutter/material.dart';

class WeatherThemeMapper {
  WeatherThemeMapper._();

  static List<Color> getGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [
          const Color(0xFFFFC107), // warm yellow
          const Color(0xFFFF9800), // orange
        ];

      case 'clouds':
        return [
          const Color(0xFF90A4AE), // blue grey
          const Color(0xFF607D8B),
        ];

      case 'rain':
      case 'drizzle':
        return [
          const Color(0xFF546E7A), // darker grey
          const Color(0xFF37474F),
        ];

      case 'thunderstorm':
        return [
          const Color(0xFF37474F),
          const Color(0xFF263238),
        ];

      case 'snow':
        return [
          const Color(0xFFE1F5FE),
          const Color(0xFF81D4FA),
        ];

      default:
        return [
          const Color(0xFF5B5FFF),
          const Color(0xFF3F51B5),
        ];
    }
  }
}