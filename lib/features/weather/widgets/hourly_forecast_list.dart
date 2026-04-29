import 'package:flutter/material.dart';

import '../data/models/forecast_model.dart';
import 'hourly_forecast_card.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecast;

  const HourlyForecastList({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final hourlyForecast = forecast.take(6).toList();

    if (hourlyForecast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Forecast',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyForecast.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + (index * 80)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(20 * (1 - value), 0),
                      child: child,
                    ),
                  );
                },
                child: HourlyForecastCard(
                  forecast: hourlyForecast[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}