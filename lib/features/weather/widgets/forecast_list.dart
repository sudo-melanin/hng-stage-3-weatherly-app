import 'package:flutter/material.dart';

import '../data/models/forecast_model.dart';
import 'forecast_card.dart';

class ForecastList extends StatelessWidget {
  final List<ForecastModel> forecast;

  const ForecastList({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final dailyForecast = _getDailyForecast(forecast);

    if (dailyForecast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5-Day Forecast',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 155,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dailyForecast.length,
            itemBuilder: (context, index) {
              return ForecastCard(forecast: dailyForecast[index]);
            },
          ),
        ),
      ],
    );
  }

  List<ForecastModel> _getDailyForecast(List<ForecastModel> forecast) {
    final Map<String, ForecastModel> groupedForecast = {};

    for (final item in forecast) {
      final dateKey =
          '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';

      groupedForecast.putIfAbsent(dateKey, () => item);
    }

    return groupedForecast.values.take(5).toList();
  }
}