import 'package:flutter/material.dart';

class WeatherIconMapper {
  WeatherIconMapper._();

  static IconData getIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
        return Icons.cloud_rounded;

      case 'rain':
        case 'drizzle':
          return Icons.cloudy_snowing;
      case 'thunderstorm':
        return Icons.flash_on_rounded;

      case 'snow':
        return Icons.ac_unit_rounded;

      case 'clear':
        return Icons.wb_sunny_rounded;

      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on_rounded;

      default:
        return Icons.cloud_queue_rounded;
    }
  }
}