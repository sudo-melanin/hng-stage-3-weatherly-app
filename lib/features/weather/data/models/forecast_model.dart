class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String condition;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];
    final wind = json['wind'];

    return ForecastModel(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: (main['temp'] as num).toDouble(),
      minTemperature: (main['temp_min'] as num).toDouble(),
      maxTemperature: (main['temp_max'] as num).toDouble(),
      condition: weather['main'] ?? '',
      description: weather['description'] ?? '',
      iconCode: weather['icon'] ?? '01d',
      humidity: main['humidity'] ?? 0,
      windSpeed: (wind['speed'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'temperature': temperature,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'condition': condition,
      'description': description,
      'iconCode': iconCode,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }

  factory ForecastModel.fromCache(Map<dynamic, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.parse(json['dateTime']),
      temperature: (json['temperature'] as num).toDouble(),
      minTemperature: (json['minTemperature'] as num).toDouble(),
      maxTemperature: (json['maxTemperature'] as num).toDouble(),
      condition: json['condition'] ?? '',
      description: json['description'] ?? '',
      iconCode: json['iconCode'] ?? '01d',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['windSpeed'] as num).toDouble(),
    );
  }
}