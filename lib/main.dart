import 'package:flutter/material.dart';
import 'package:pak_tani/src/app.dart';
import 'package:pak_tani/src/core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjection.init();

  runApp(const MyApp());
}
