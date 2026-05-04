import 'package:flutter/material.dart';

import '../providers/weather_provider.dart';
import 'mobile_weather_layout.dart';
import 'wide_weather_layout.dart';

class AdaptiveWeatherLayout extends StatelessWidget {
  final WeatherProvider weatherProvider;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool isSearching;
  final VoidCallback onToggleSearch;
  final VoidCallback onSearchCity;

  const AdaptiveWeatherLayout({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 900;

        if (isWideScreen) {
          return WideWeatherLayout(
            weatherProvider: weatherProvider,
            searchController: searchController,
            searchFocusNode: searchFocusNode,
            isSearching: isSearching,
            onToggleSearch: onToggleSearch,
            onSearchCity: onSearchCity,
          );
        }

        return MobileWeatherLayout(
          weatherProvider: weatherProvider,
          searchController: searchController,
          searchFocusNode: searchFocusNode,
          isSearching: isSearching,
          onToggleSearch: onToggleSearch,
          onSearchCity: onSearchCity,
        );
      },
    );
  }
}