import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pak_tani/src/app.dart';
import 'package:pak_tani/src/core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await DependencyInjection.init();

  runApp(const MyApp());
}
