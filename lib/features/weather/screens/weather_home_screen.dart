import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_weather_card.dart';
import '../layouts/adaptive_weather_layout.dart';

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
            // Handle snackbar errors
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

            // Loading state
            if (weatherProvider.isLoading) {
              return const LoadingWeatherCard();
            }

            // Empty / error state
            if (!weatherProvider.hasWeatherData) {
              return ErrorView(
                message: weatherProvider.errorMessage ??
                    'No weather data available yet. Please try again or search for a city.',
                onRetry: () => weatherProvider.searchWeatherByCity('Lagos'),
              );
            }

            // MAIN CHANGE: Use adaptive layout instead of building UI here
            return AdaptiveWeatherLayout(
              weatherProvider: weatherProvider,
              searchController: _searchController,
              isSearching: _isSearching,
              onToggleSearch: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              onSearchCity: _searchCity,
            );
          },
        ),
      ),
    );
  }
}