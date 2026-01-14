import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pak_tani/firebase_options.dart';
import 'package:pak_tani/src/app.dart';
import 'package:pak_tani/src/core/config/firebase_cloud_messaging_config.dart';
import 'package:pak_tani/src/core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Minimal initialization for background isolate
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await DependencyInjection.init();

  await FirebaseCloudMessagingConfig.initialize();

  runApp(const MyApp());
}
