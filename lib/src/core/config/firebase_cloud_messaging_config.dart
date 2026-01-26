/// Configuration class for Firebae Cloud Messaging (FCM) and local notifications.
/// Handles intialization, token management, dan notification display.
/// This ensures FCM is initialized only once per app session and manages device registration

library;

import 'dart:io';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/features/notification/application/services/notification_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Global instance for local notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Notification channel for high-importance notification (Android 8+)
const AndroidNotificationChannel _highImportanceChannel =
    AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Channel for important notifications',
      importance: Importance.max,
    );

/// configuration class for FCM and notification
class FirebaseCloudMessagingConfig {
  static bool _initialized = false; //Flag to prevent re-initialization

  ///Initializes FCM and local notification only once.
  ///This include requesting permissions, setting up channels, and listeners.
  ///Call this in main() to ensure setup on app launch
  static Future<void> initialize() async {
    if (_initialized) {
      print("FCM: alredy initilasized, skipping");
      return;
    }
    _initialized = true;

    print("init notifikasi");

    await _requestNotificationPermission();
    await _initializeLocalNotifications();
    await _createNotificationChannel();
    _setupMessageListeners();

    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// Request notification permission on Android 13+
  /// Ensures the app can display notification.
  static Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initAndroid =
        AndroidInitializationSettings('icon_notif');
    const InitializationSettings initSettings = InitializationSettings(
      android: initAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap, (e.g., navigate to a screen)
      },
    );
  }

  /// Creates the notification channel on Android.
  static Future<void> _createNotificationChannel() async {
    final androidImpl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.createNotificationChannel(_highImportanceChannel);
  }

  /// Sets up listeners for FCM messages.
  static void _setupMessageListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('FCM onMessage: ${message.data} ${message.notification}');
      final notificationService = Get.find<NotificationService>();
      notificationService.loadAllNotificationItems();

      final notification = message.notification;

      // Extract title and body from notification or data payload
      final title = notification?.title ?? message.data['title'];
      final body = notification?.body ?? message.data['body'];
      final imageUrl =
          (message.data['image'] as String?) ??
          (notification?.android?.imageUrl?.toString());

      // skip local notification if app is not in foreground
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

  /// retrives the FCM token.
  /// returns null if available.
  static Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  /// sends FCM token and device info to the server if not alredy registered.
  /// Uses storage to track registrations status
  static Future<void> sendTokenAndDeviceInfo(String tokenFCM) async {
    final apiService = Get.find<ApiService>();
    final storageService = Get.find<StorageService>();

    final isRegistered = storageService.readBool("is_notification_registered");
    if (isRegistered == true) {
      print("fcm sudah pernah didaftarkan");
      return;
    }

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final String androidName = androidInfo.device;
      final String andoridId = androidInfo.id;

      final Map<String, dynamic> data = {
        "registration_id": tokenFCM,
        "device_id": andoridId,
        "name": androidName,
        "type": "android", // can be "ios", "web", or "android"
        "active": true,
      };

      await apiService.post("/devices/", data: data);
      storageService.writeBool("is_notification_registered", true);
      print("berhasil mendaftarkan fcm");
    } catch (e) {
      print("error mendaftarkan fcm: $e");
    }
  }

  ///Downloads and save an image file, optionally resizing it.
  /// Returns the file path or null on failure
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

      // Resize image for thumnail
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

  /// Displays a local notification with optional image.
  /// Skips if title and body are empty.
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

  static void _handleNotificationTap(RemoteMessage message) {
    final storageService = Get.find<StorageService>();
    final String? serialId = message.data["serial_id"];
    final int? schedule = int.tryParse(
      message.data["schedule"]?.toString() ?? '',
    );

    if (serialId != null) {
      storageService.write("notification_serial_id", serialId);
      if (schedule != null) {
        storageService.writeInt("notification_schedule", schedule);
      }
      print("data notifikasi tersimpan");
    }
    print("data notifikasi: ${message.data}");
    print(
      "serial_id data: ${message.data["serial_id"]} | tipe data: ${message.data["serial_id"].runtimeType}",
    );

    print(
      "schedule data: ${message.data["schedule"]} | tipe data: ${message.data["schedule"].runtimeType}",
    );
  }
}
