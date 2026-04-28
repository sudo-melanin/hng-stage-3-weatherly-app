class CurrentWeatherModel {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final String condition;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final DateTime dateTime;

  CurrentWeatherModel({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.dateTime,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];
    final wind = json['wind'];

    return CurrentWeatherModel(
      cityName: json['name'] ?? 'Unknown location',
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      condition: weather['main'] ?? '',
      description: weather['description'] ?? '',
      iconCode: weather['icon'] ?? '01d',
      humidity: main['humidity'] ?? 0,
      windSpeed: (wind['speed'] as num).toDouble(),
      pressure: main['pressure'] ?? 0,
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'condition': condition,
      'description': description,
      'iconCode': iconCode,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pressure': pressure,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory CurrentWeatherModel.fromCache(Map<dynamic, dynamic> json) {
    return CurrentWeatherModel(
      cityName: json['cityName'] ?? 'Unknown location',
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      condition: json['condition'] ?? '',
      description: json['description'] ?? '',
      iconCode: json['iconCode'] ?? '01d',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      pressure: json['pressure'] ?? 0,
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}