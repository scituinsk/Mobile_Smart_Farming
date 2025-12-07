import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
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

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin bgPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initAndroid =
      AndroidInitializationSettings('icon_notif');
  const InitializationSettings initSettings = InitializationSettings(
    android: initAndroid,
  );
  await bgPlugin.initialize(initSettings);

  // Ensure channel exists in background isolate
  final androidImpl = bgPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  await androidImpl?.createNotificationChannel(_highImportanceChannel);

  final notification = message.notification;
  final title = notification?.title ?? message.data['title'];
  final body = notification?.body ?? message.data['body'];

  if ((title == null || title.trim().isEmpty) &&
      (body == null || body.trim().isEmpty)) {
    print('FCM Background: Skipping empty notification.');
    return;
  }

  final imageUrl =
      (message.data['image'] as String?) ??
      (notification?.android?.imageUrl?.toString());

  String? imagePath;
  if (imageUrl != null && imageUrl.isNotEmpty) {
    final fileName = "notif_${DateTime.now().millisecondsSinceEpoch}.png";
    imagePath = await FirebaseCloudMessagingConfig._downloadAndSaveFile(
      imageUrl,
      fileName,
    );
  }

  AndroidNotificationDetails androidDetails;
  if (imagePath != null) {
    final bigPicture = FilePathAndroidBitmap(imagePath);
    final largeIcon = FilePathAndroidBitmap(imagePath);
    final bigStyle = BigPictureStyleInformation(
      bigPicture,
      largeIcon: largeIcon,
      contentTitle: title,
      summaryText: body,
    );
    androidDetails = AndroidNotificationDetails(
      _highImportanceChannel.id,
      _highImportanceChannel.name,
      channelDescription: _highImportanceChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'icon_notif',
      styleInformation: bigStyle,
      colorized: false,
    );
  } else {
    androidDetails = AndroidNotificationDetails(
      _highImportanceChannel.id,
      _highImportanceChannel.name,
      channelDescription: _highImportanceChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'icon_notif',
      colorized: false,
    );
  }

  await bgPlugin.show(
    DateTime.now().millisecondsSinceEpoch.remainder(100000),
    title ?? "",
    body ?? "",
    NotificationDetails(android: androidDetails),
  );
}

class FirebaseCloudMessagingConfig {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      print("FCM: alredy initilasized, skipping");
      return;
    }
    _initialized = true;

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

    // register background handler only on Android (must be top-level & annotated)
    // if (Platform.isAndroid) {
    //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('FCM onMessage: ${message.data} ${message.notification}');
      final notification = message.notification;

      // jika payload tidak memiliki notification, tampilkan menggunakan data yang ada
      final title = notification?.title ?? message.data['title'];
      final body = notification?.body ?? message.data['body'];

      final imageUrl =
          (message.data['image'] as String?) ??
          (notification?.android?.imageUrl?.toString());

      final isForeground =
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
      if (!isForeground) {
        print(
          "FCM onMessage reviced while not in foreground - skip local notification",
        );
        return;
      }

      if ((title != null || body != null)) {
        await _showNotificationWithImage(
          title: title,
          body: body,
          imageUrl: imageUrl,
        );
      }
    });
  }

  static Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }

  static Future<String?> _downloadAndSaveFile(
    String url,
    String fileName, {
    int? targetWidth,
  }) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = "${tempDir.path}/$fileName";
      final HttpClientRequest req = await HttpClient().getUrl(Uri.parse(url));
      final HttpClientResponse resp = await req.close();
      if (resp.statusCode != 200) return null;
      final bytes = await consolidateHttpClientResponseBytes(resp);

      if (targetWidth == null) {
        final File file = File(filePath);
        await file.writeAsBytes(bytes);
        return filePath;
      }

      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: targetWidth,
      );
      final frame = await codec.getNextFrame();
      final ui.Image resized = frame.image;
      final ByteData? byteData = await resized.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) return null;
      final resizedBytes = byteData.buffer.asUint8List();
      final File file = File(filePath);
      await file.writeAsBytes(resizedBytes);
      return filePath;
    } catch (e) {
      print("Download/resize image failed: $e");
      return null;
    }
  }

  static Future<void> _showNotificationWithImage({
    required String? title,
    required String? body,
    required String? imageUrl,
  }) async {
    if ((title == null || title.trim().isEmpty) &&
        (body == null || body.trim().isEmpty)) {
      print('FCM Foreground: Skipping empty notification.');
      return;
    }
    String? imagePath;
    String? thumbPath;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final fileName = "notif_${DateTime.now().millisecondsSinceEpoch}.png";
      imagePath = await _downloadAndSaveFile(
        imageUrl,
        fileName,
        targetWidth: null,
      );
      final thumbName =
          "notif_thumb_${DateTime.now().millisecondsSinceEpoch}.png";
      thumbPath = await _downloadAndSaveFile(
        imageUrl,
        thumbName,
        targetWidth: 128,
      );
    }

    AndroidNotificationDetails androidDetails;
    if (imagePath != null) {
      final bigPicture = FilePathAndroidBitmap(imagePath);
      final largeIcon = FilePathAndroidBitmap(thumbPath ?? imagePath);
      final bigStyle = BigPictureStyleInformation(
        bigPicture,
        largeIcon: largeIcon,
        contentTitle: title,
        summaryText: body,
        hideExpandedLargeIcon: true,
      );
      androidDetails = AndroidNotificationDetails(
        _highImportanceChannel.id,
        _highImportanceChannel.name,
        channelDescription: _highImportanceChannel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: 'icon_notif',
        styleInformation: bigStyle,
        colorized: false,
      );
    } else {
      androidDetails = AndroidNotificationDetails(
        _highImportanceChannel.id,
        _highImportanceChannel.name,
        channelDescription: _highImportanceChannel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: 'icon_notif',
        colorized: false,
      );
    }

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title ?? "",
      body ?? "",
      NotificationDetails(android: androidDetails),
    );
  }
}
