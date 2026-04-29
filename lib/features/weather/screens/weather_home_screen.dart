import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/weather_icon_mapper.dart';
import '../../../core/utils/weather_theme_mapper.dart';
import '../providers/weather_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/forecast_list.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/loading_weather_card.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  void _searchCity() {
    final city = _searchController.text.trim();

    FocusScope.of(context).unfocus();

    context.read<WeatherProvider>().searchWeatherByCity(city);

    if (city.isNotEmpty) {
      _searchController.clear();

      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Wait until the first frame is ready before calling Provider.
    // This keeps the startup fetch away from the initial build process.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().searchWeatherByCity('Lagos');
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
            if (weatherProvider.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;

                final message = weatherProvider.errorMessage!;

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                context.read<WeatherProvider>().clearError();
              });
            }

            if (weatherProvider.isLoading) {
              return const LoadingWeatherCard();
            }

            if (!weatherProvider.hasWeatherData) {
              return ErrorView(
                message: weatherProvider.errorMessage ??
                    'No weather data available yet. Please try again or search for a city.',
                onRetry: () => weatherProvider.searchWeatherByCity('Lagos'),
              );
            }

            final weather = weatherProvider.currentWeather!;
            final gradientColors =
                WeatherThemeMapper.getGradient(weather.condition);

            return RefreshIndicator(
              onRefresh: weatherProvider.loadWeatherByLocation,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Weatherly',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Use current location',
                        onPressed: weatherProvider.loadWeatherByLocation,
                        icon: const Icon(Icons.my_location_rounded),
                      ),
                      IconButton(
                        tooltip: 'Search city',
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                        },
                        icon: Icon(
                          _isSearching
                              ? Icons.close_rounded
                              : Icons.search_rounded,
                        ),
                      ),
                    ],
                  ),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _isSearching
                        ? Padding(
                            key: const ValueKey('search-field'),
                            padding: const EdgeInsets.only(top: 12),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => _searchCity(),
                              decoration: InputDecoration(
                                hintText: 'Search city, e.g. Lagos',
                                prefixIcon: const Icon(Icons.search_rounded),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.send_rounded),
                                  onPressed: _searchCity,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 20),

                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 32 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 28,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Column(
                              key: ValueKey(
                                '${weather.cityName}-${weather.description}',
                              ),
                              children: [
                                Text(
                                  weather.countryCode.isEmpty
                                      ? weather.cityName
                                      : '${weather.cityName}, ${weather.countryCode}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  weather.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Icon(
                            WeatherIconMapper.getIcon(weather.condition),
                            size: 54,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 14),
                          AnimatedSwitcher(
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
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
                        color: const Color(0xFFF8F9FD),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 20,
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