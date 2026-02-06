/// Configuration class for environtment variables (ENV).
/// Provides centralized access to app settings loaded from .env file.
/// Uses flutter_dotenv to retrive values safely.

library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class for app environtment settings.
class AppConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
  static String get apiBaseUrl => dotenv.env['API_BASE_URL']!;
  static String get imageUrl => dotenv.env['IMAGE_URL']!;
  static int get timeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? "10") ?? 10;
  static String wsBaseUrl = dotenv.env['WS_BASE_URL']!;
}
