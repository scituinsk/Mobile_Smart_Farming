import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
  static String get apiBaseUrl => dotenv.env['API_BASE_URL']!;
  static int get timeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? "10") ?? 10;
}
