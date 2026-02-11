import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

class LogUtils {
  static final Logger _logger = Logger(
    level: kDebugMode ? Level.all : Level.off,
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  ///print debug
  static void d(String message) {
    _logger.d(message);
  }

  /// print info
  static void i(String message) {
    _logger.i(message);
  }

  ///print warning
  static void w(String message, [dynamic error]) {
    _logger.w(message, error: error);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
