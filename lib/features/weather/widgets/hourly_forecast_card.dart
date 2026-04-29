import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../data/models/forecast_model.dart';

class HourlyForecastCard extends StatelessWidget {
  final ForecastModel forecast;

  const HourlyForecastCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormatter.hour(forecast.dateTime),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 10),
          Icon(
            WeatherIconMapper.getIcon(forecast.condition),
            size: 28,
            color: Colors.blueGrey.shade700,
          ),
          const SizedBox(height: 10),
          Text(
            '${forecast.temperature.round()}°',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}