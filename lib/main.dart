import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/weather/providers/weather_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the API key from the .env file before the app starts.
  await dotenv.load(fileName: ".env");

  // Hive needs to be initialized before we can read or save cached weather data.
  await Hive.initFlutter();

  // This box will store the last successful weather response for offline use.
  await Hive.openBox('weather_cache');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
        ),
      ],
      child: const WeatherApp(),
    ),
  );
}