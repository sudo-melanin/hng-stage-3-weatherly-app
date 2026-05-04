import 'package:flutter/material.dart';

import '../../../core/utils/weather_icon_mapper.dart';
import '../../../core/utils/weather_theme_mapper.dart';
import '../data/models/current_weather_model.dart';
import '../providers/weather_provider.dart';
import '../widgets/forecast_list.dart';
import '../widgets/hourly_forecast_list.dart';

class WideWeatherLayout extends StatelessWidget {
  final WeatherProvider weatherProvider;
  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback onToggleSearch;
  final VoidCallback onSearchCity;
  final FocusNode searchFocusNode;

  const WideWeatherLayout({
    super.key,
    required this.weatherProvider,
    required this.searchController,
    required this.isSearching,
    required this.onToggleSearch,
    required this.onSearchCity,
    required this.searchFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final weather = weatherProvider.currentWeather!;
    final gradientColors = WeatherThemeMapper.getGradient(weather.condition);

    return RefreshIndicator(
      onRefresh: weatherProvider.loadWeatherByLocation,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _DesktopMenuBar(
                  onSearchCity: onToggleSearch,
                  onRefresh: weatherProvider.loadWeatherByLocation,
                  onUseLocation: weatherProvider.loadWeatherByLocation,
                  onLoadDefault: weatherProvider.loadDefaultCity,
                ),

                const SizedBox(height: 16),
                _DesktopTopBar(
                  isSearching: isSearching,
                  onToggleSearch: onToggleSearch,
                  onUseLocation: weatherProvider.loadWeatherByLocation,
                ),
                _DesktopSearchField(
                  isSearching: isSearching,
                  controller: searchController,
                  onSearchCity: onSearchCity,
                  searchFocusNode: searchFocusNode,
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          _WideHeroWeatherCard(
                            weather: weather,
                            gradientColors: gradientColors,
                          ),
                          const SizedBox(height: 24),
                          _WideWeatherDetailsCard(weather: weather),
                        ],
                      ),
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 22,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HourlyForecastList(
                              forecast: weatherProvider.forecast,
                            ),
                            const SizedBox(height: 28),
                            ForecastList(
                              forecast: weatherProvider.forecast,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopTopBar extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onToggleSearch;
  final Future<void> Function() onUseLocation;

  const _DesktopTopBar({
    required this.isSearching,
    required this.onToggleSearch,
    required this.onUseLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Weatherly',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        _HoverActionButton(
          tooltip: 'Use current location',
          icon: Icons.my_location_rounded,
          label: 'Location',
          onPressed: onUseLocation,
        ),
        const SizedBox(width: 12),
        _HoverActionButton(
          tooltip: 'Search city (Alt + S)',
          icon: isSearching ? Icons.close_rounded : Icons.search_rounded,
          label: isSearching ? 'Close' : 'Search',
          onPressed: onToggleSearch,
        ),
      ],
    );
  }
}

class _DesktopSearchField extends StatelessWidget {
  final bool isSearching;
  final TextEditingController controller;
  final VoidCallback onSearchCity;
  final FocusNode searchFocusNode;

  const _DesktopSearchField({
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
              key: const ValueKey('desktop-search-field'),
              padding: const EdgeInsets.only(top: 18),
              child: TextField(
                focusNode: searchFocusNode,
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => onSearchCity(),
                decoration: InputDecoration(
                  hintText: 'Search city, e.g. Lagos, Accra, London',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    tooltip: 'Search',
                    icon: const Icon(Icons.send_rounded),
                    onPressed: onSearchCity,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _WideHeroWeatherCard extends StatelessWidget {
  final CurrentWeatherModel weather;
  final List<Color> gradientColors;

  const _WideHeroWeatherCard({
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
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.countryCode.isEmpty
                        ? weather.cityName
                        : '${weather.cityName}, ${weather.countryCode}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weather.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
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
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Icon(
              WeatherIconMapper.getIcon(weather.condition),
              size: 84,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _WideWeatherDetailsCard extends StatelessWidget {
  final CurrentWeatherModel weather;

  const _WideWeatherDetailsCard({
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
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FD),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Wrap(
          runSpacing: 18,
          spacing: 18,
          children: [
            _WeatherMetricTile(
              label: 'Feels like',
              value: '${weather.feelsLike.round()}°C',
              icon: Icons.thermostat_rounded,
            ),
            _WeatherMetricTile(
              label: 'Humidity',
              value: '${weather.humidity}%',
              icon: Icons.water_drop_rounded,
            ),
            _WeatherMetricTile(
              label: 'Wind speed',
              value: '${weather.windSpeed} m/s',
              icon: Icons.air_rounded,
            ),
            _WeatherMetricTile(
              label: 'Pressure',
              value: '${weather.pressure} hPa',
              icon: Icons.speed_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _WeatherMetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blueGrey.withValues(alpha: 0.08),
            child: Icon(
              icon,
              color: Colors.blueGrey.shade700,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverActionButton extends StatefulWidget {
  final String tooltip;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _HoverActionButton({
    required this.tooltip,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<_HoverActionButton> createState() => _HoverActionButtonState();
}

class _HoverActionButtonState extends State<_HoverActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.blueGrey.withValues(alpha: 0.12)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.04),
                blurRadius: _isHovered ? 14 : 8,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextButton.icon(
            onPressed: widget.onPressed,
            icon: Icon(widget.icon),
            label: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _DesktopMenuBar extends StatelessWidget {
  final VoidCallback onSearchCity;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onUseLocation;
  final Future<void> Function() onLoadDefault;

  const _DesktopMenuBar({
    required this.onSearchCity,
    required this.onRefresh,
    required this.onUseLocation,
    required this.onLoadDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
         color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.00),
        ),
      ),
      child: Row(
        children: [
          _MenuGroup(
            label: 'File',
            items: [
              _MenuAction(
                label: 'Search City',
                shortcut: 'Alt + S',
                onTap: onSearchCity,
              ),
              _MenuAction(
                label: 'Load Default',
                shortcut: 'Alt + D',
                onTap: onLoadDefault,
              ),
            ],
          ),
          _MenuGroup(
            label: 'View',
            items: [
              _MenuAction(
                label: 'Refresh Weather',
                shortcut: 'Alt + R',
                onTap: onRefresh,
              ),
              _MenuAction(
                label: 'Use Current Location',
                shortcut: 'Alt + L',
                onTap: onUseLocation,
              ),
            ],
          ),
          _MenuGroup(
            label: 'Help',
            items: [
              _MenuAction(
                label: 'About Weatherly',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Weatherly',
                    applicationVersion: 'Stage 4 Cross-Platform',
                    applicationLegalese:
                        'Built as part of the HNG Internship Mobile Track.',
                    children: const [
                      SizedBox(height: 12),
                      Text(
                        'Weatherly is a cross-platform Flutter weather app with mobile, web, and desktop support.',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  final String label;
  final List<_MenuAction> items;

  const _MenuGroup({
    required this.label,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      tooltip: label,
      offset: const Offset(0, 36),
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<_MenuAction>(
            value: item,
            child: Row(
              children: [
                Expanded(child: Text(item.label)),
                if (item.shortcut != null) ...[
                  const SizedBox(width: 24),
                  Text(
                    item.shortcut!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ],
              ],
            ),
          );
        }).toList();
      },
      onSelected: (item) => item.onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),
    );
  }
}

class _MenuAction {
  final String label;
  final String? shortcut;
  final VoidCallback onTap;

  const _MenuAction({
    required this.label,
    required this.onTap,
    this.shortcut,
  });
}