import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  @override
  void initState() {
    super.initState();

    // We wait until the first frame is built before calling Provider.
    // This avoids using context too early during screen initialization.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            if (weatherProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!weatherProvider.hasWeatherData) {
              return _EmptyWeatherState(
                message: weatherProvider.errorMessage ??
                    'No weather data available yet.',
                onRetry: weatherProvider.loadWeatherByLocation,
              );
            }

            final weather = weatherProvider.currentWeather!;

            return RefreshIndicator(
              onRefresh: weatherProvider.loadWeatherByLocation,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 12),

                  Text(
                    weather.cityName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    weather.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: Text(
                      '${weather.temperature.round()}°C',
                      style:
                          Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _WeatherDetailRow(
                            label: 'Feels like',
                            value: '${weather.feelsLike.round()}°C',
                          ),
                          _WeatherDetailRow(
                            label: 'Humidity',
                            value: '${weather.humidity}%',
                          ),
                          _WeatherDetailRow(
                            label: 'Wind speed',
                            value: '${weather.windSpeed} m/s',
                          ),
                          _WeatherDetailRow(
                            label: 'Pressure',
                            value: '${weather.pressure} hPa',
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (weatherProvider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      weatherProvider.errorMessage!,
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WeatherDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _WeatherDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _EmptyWeatherState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _EmptyWeatherState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}