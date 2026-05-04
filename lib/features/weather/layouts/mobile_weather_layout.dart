import 'package:flutter/material.dart';

import '../../../core/utils/weather_icon_mapper.dart';
import '../../../core/utils/weather_theme_mapper.dart';
import '../data/models/current_weather_model.dart';
import '../providers/weather_provider.dart';
import '../widgets/forecast_list.dart';
import '../widgets/hourly_forecast_list.dart';

class MobileWeatherLayout extends StatelessWidget {
  final WeatherProvider weatherProvider;
  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback onToggleSearch;
  final VoidCallback onSearchCity;
  final FocusNode searchFocusNode;

  const MobileWeatherLayout({
    super.key,
    required this.weatherProvider,
    required this.searchController,
    required this.searchFocusNode,
    required this.isSearching,
    required this.onToggleSearch,
    required this.onSearchCity,
  });

  @override
  Widget build(BuildContext context) {
    final weather = weatherProvider.currentWeather!;
    final gradientColors = WeatherThemeMapper.getGradient(weather.condition);

    return RefreshIndicator(
      onRefresh: weatherProvider.loadWeatherByLocation,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          _TopBar(
            isSearching: isSearching,
            onToggleSearch: onToggleSearch,
            onUseLocation: weatherProvider.loadWeatherByLocation,
          ),
          _SearchField(
            isSearching: isSearching,
            controller: searchController,
            onSearchCity: onSearchCity,
            searchFocusNode: searchFocusNode,
          ),
          const SizedBox(height: 20),
          _HeroWeatherCard(
            weather: weather,
            gradientColors: gradientColors,
          ),
          const SizedBox(height: 28),
          _WeatherDetailsCard(weather: weather),
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
  }
}

class _TopBar extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onToggleSearch;
  final Future<void> Function() onUseLocation;
  

  const _TopBar({
    required this.isSearching,
    required this.onToggleSearch,
    required this.onUseLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Weatherly',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        IconButton(
          tooltip: 'Use current location (Alt + L)',
          onPressed: onUseLocation,
          icon: const Icon(Icons.my_location_rounded),
        ),
        IconButton(
          tooltip: 'Search city (Alt + S)',
          onPressed: onToggleSearch,
          icon: Icon(
            isSearching ? Icons.close_rounded : Icons.search_rounded,
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final bool isSearching;
  final TextEditingController controller;
  final VoidCallback onSearchCity;
  final FocusNode searchFocusNode;

  const _SearchField({
    required this.isSearching,
    required this.controller,
    required this.onSearchCity,
    required this.searchFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isSearching
          ? Padding(
              key: const ValueKey('search-field'),
              padding: const EdgeInsets.only(top: 12),
              child: TextField(
                focusNode: searchFocusNode,
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => onSearchCity(),
                decoration: InputDecoration(
                  hintText: 'Search city, e.g. Lagos',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: onSearchCity,
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
    );
  }
}

class _HeroWeatherCard extends StatelessWidget {
  final CurrentWeatherModel weather;
  final List<Color> gradientColors;

  const _HeroWeatherCard({
    required this.weather,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
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
                key: ValueKey('${weather.cityName}-${weather.description}'),
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
    );
  }
}

class _WeatherDetailsCard extends StatelessWidget {
  final CurrentWeatherModel weather;

  const _WeatherDetailsCard({
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
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