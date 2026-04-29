import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/weather_icon_mapper.dart';
import '../providers/weather_provider.dart';
import '../widgets/forecast_list.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _searchCity() {
    final city = _searchController.text.trim();

    FocusScope.of(context).unfocus();
    context.read<WeatherProvider>().searchWeatherByCity(city);
  }

  @override
  void initState() {
    super.initState();

    // Wait until the first frame is ready before calling Provider.
    // This keeps the startup fetch away from the initial build process.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadWeatherByLocation();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            if (weatherProvider.isLoading) {
              return const LoadingWeatherCard();
            }

            if (!weatherProvider.hasWeatherData) {
              return ErrorView(
                message: weatherProvider.errorMessage ??
                    'No weather data available yet. Please try again or search for a city.',
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

                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _searchCity(),
                    decoration: InputDecoration(
                      hintText: 'Search city, e.g. Lagos',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.my_location_rounded),
                        onPressed: weatherProvider.loadWeatherByLocation,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _searchCity,
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Search Weather'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(
                        '${weather.cityName}-${weather.description}',
                      ),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          weather.cityName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          weather.description,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Icon(
                      WeatherIconMapper.getIcon(weather.condition),
                      size: 72,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        '${weather.temperature.round()}°C',
                        key: ValueKey(weather.temperature.round()),
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 24 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
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

                  const SizedBox(height: 28),

                  HourlyForecastList(
                    forecast: weatherProvider.forecast,
                  ),

                  const SizedBox(height: 24),

                  ForecastList(
                    forecast: weatherProvider.forecast,
                  ),

                  if (weatherProvider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              weatherProvider.errorMessage!,
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
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