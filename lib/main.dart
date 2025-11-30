import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pak_tani/firebase_options.dart';
import 'package:pak_tani/src/app.dart';
import 'package:pak_tani/src/core/config/firebase_cloud_messaging_config.dart';
import 'package:pak_tani/src/core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await DependencyInjection.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseCloudMessagingConfig.initialize();

  FirebaseMessaging.onBackgroundMessage(
    FirebaseCloudMessagingConfig.firebaseMessagingBackgroundHandler,
  );

  await FirebaseCloudMessagingConfig.getToken();

  runApp(const MyApp());
}
