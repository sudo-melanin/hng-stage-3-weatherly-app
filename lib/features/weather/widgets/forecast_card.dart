import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/constants/api_constants.dart';
import '../data/models/forecast_model.dart';

class ForecastCard extends StatelessWidget {
  final ForecastModel forecast;

  const ForecastCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormatter.dayName(forecast.dateTime),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Image.network(
              ApiConstants.weatherIconUrl(forecast.iconCode),
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 8),
            Text(
              '${forecast.temperature.round()}°C',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              forecast.condition,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}