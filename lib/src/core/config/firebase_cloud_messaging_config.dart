import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// buat channel sekali saja (Android 8+)
const AndroidNotificationChannel _highImportanceChannel =
    AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'Channel for important notifications',
      importance: Importance.max,
    );

class FirebaseCloudMessagingConfig {
  static Future<void> initialize() async {
    print("init notifikasi");

    // request runtime permission (Android 13+)
    if (Platform.isAndroid) {
      // pastikan menambahkan permission_handler di pubspec.yaml
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }

    // initialize local notifications
    const AndroidInitializationSettings initAndroid =
        AndroidInitializationSettings('icon_notif');
    const InitializationSettings initSettings = InitializationSettings(
      android: initAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // handle notification tapped
      },
    );

    // buat channel Android secara eksplisit
    final androidImpl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.createNotificationChannel(_highImportanceChannel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('FCM onMessage: ${message.data} ${message.notification}');
      final notification = message.notification;
      // final android = message.notification?.android;

      // jika payload tidak memiliki notification, tampilkan menggunakan data yang ada
      final title = notification?.title ?? message.data['title'];
      final body = notification?.body ?? message.data['body'];

      if ((title != null || body != null)) {
        flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch.remainder(100000),
          title,
          body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _highImportanceChannel.id,
              _highImportanceChannel.name,
              channelDescription: _highImportanceChannel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: 'icon_notif',
              color: const Color(0x00000000),
              colorized: false,
            ),
          ),
        );
      }
    });
  }

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    print("Pesan diterima di background: ${message.data}");
  }

  static Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }
}
