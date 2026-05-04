import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _rootFocusNode = FocusNode();

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

  void _showContextMenu(Offset position) async {
  final selected = await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx,
      position.dy,
    ),
    items: [
      const PopupMenuItem(
        value: 'refresh',
        child: Text('Refresh Weather'),
      ),
      const PopupMenuItem(
        value: 'location',
        child: Text('Use Current Location'),
      ),
      const PopupMenuItem(
        value: 'search',
        child: Text('Search City'),
      ),
      const PopupMenuItem(
        value: 'default',
        child: Text('Load Default'),
      ),
    ],
  );

  if (selected == null) return;
  if (!mounted) return;

  switch (selected) {
    case 'refresh':
      context.read<WeatherProvider>().loadWeatherByLocation();
      break;

    case 'location':
      context.read<WeatherProvider>().loadWeatherByLocation();
      break;

    case 'search':
      setState(() => _isSearching = true);
      Future.delayed(const Duration(milliseconds: 100), () {
        _searchFocusNode.requestFocus();
      });
      break;

    case 'default':
      context.read<WeatherProvider>().loadDefaultCity();
      break;
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
    _searchFocusNode.dispose();
    _rootFocusNode.dispose();
    super.dispose();
  }

  void _handleKeyboardShortcut(KeyEvent event) {
  if (event is! KeyDownEvent) return;

  final isAltPressed = HardwareKeyboard.instance.isAltPressed;
  final key = event.logicalKey;

  if (isAltPressed && key == LogicalKeyboardKey.keyS) {
    setState(() => _isSearching = true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  if (isAltPressed && key == LogicalKeyboardKey.keyR) {
    context.read<WeatherProvider>().loadWeatherByLocation();
    _rootFocusNode.requestFocus();
  }

  if (isAltPressed && key == LogicalKeyboardKey.keyL) {
    context.read<WeatherProvider>().loadWeatherByLocation();
    _rootFocusNode.requestFocus();
  }

  if (isAltPressed && key == LogicalKeyboardKey.keyD) {
    context.read<WeatherProvider>().searchWeatherByCity('Lagos');
    _rootFocusNode.requestFocus();
  }

  if (key == LogicalKeyboardKey.escape) {
    setState(() => _isSearching = false);
    _searchController.clear();
    _rootFocusNode.requestFocus();
  }
}

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: _handleKeyboardShortcut,
     
          child: GestureDetector(
            onSecondaryTapDown: (details) {
              _showContextMenu(details.globalPosition);
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F4F8),
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
                      searchFocusNode: _searchFocusNode,
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
            ),
          ),
        );
  }
}


class OpenSearchIntent extends Intent {
  const OpenSearchIntent();
}

class CloseSearchIntent extends Intent {
  const CloseSearchIntent();
}

class RefreshIntent extends Intent {
  const RefreshIntent();
}

class UseLocationIntent extends Intent {
  const UseLocationIntent();
}

class LoadDefaultCityIntent extends Intent {
  const LoadDefaultCityIntent();
}