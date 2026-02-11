/// Splash screen.
/// Displays quick splash screen while waiting app initialization, checking access and refresh token,

library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/services/connectivity_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';

/// Splash screen widget.
/// Handles app initialization, connectivity check, authentication status, and navigation to appropriate page.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RxString statusMessage = 'splash_initializing'.tr.obs;
  late StorageService storageService;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    storageService = Get.find<StorageService>();
  }

  /// Initializes the app by checking connectivity, auth service, and authentication status.
  /// Navigates to the appropriate page based on auth status or shows retry dialog on error.
  Future<void> _initializeApp() async {
    try {
      statusMessage.value = "splash_checking_connection".tr;
      await Future.delayed(const Duration(milliseconds: 500));

      final connectivityService = Get.find<ConnectivityService>();
      await connectivityService.checkInitialConnection();

      if (!connectivityService.isConnected.value) {
        statusMessage.value = "splash_no_internet".tr;
        _showRetryDialog();
        return;
      }

      statusMessage.value = 'splash_starting_app'.tr;

      statusMessage.value = "splash_getting_auth".tr;
      final authService = Get.find<AuthService>();
      authService.debugInfo();

      if (!authService.isReady) {
        LogUtils.d('❌ AuthService not ready, initializing...');
        // Force wait max 3 seconds
        int attempts = 0;
        while (!authService.isReady && attempts < 30) {
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
        }

        if (!authService.isReady) {
          throw Exception('AuthService failed to initialize');
        }
      }

      statusMessage.value = 'splash_checking_auth'.tr;
      await authService.checkAuthenticationStatus();

      await Future.delayed(const Duration(milliseconds: 500));

      //  Navigate based on auth status
      if (authService.isLoggedIn.value) {
        statusMessage.value = 'splash_welcome_back'.tr;
        await Future.delayed(const Duration(milliseconds: 300));

        final serialId = await storageService.read("notification_serial_id");
        final schedule = await storageService.readInt("notification_schedule");
        Map<String, dynamic>? argument;
        if (serialId != null) {
          argument = {"serial_id": serialId};
          if (schedule != null) {
            argument = {"serial_id": serialId, "schedule": schedule};
          }
        }
        LogUtils.d("ke main screen bawa arguments: $argument");
        Get.offAllNamed(RouteNames.mainPage, arguments: argument);
        await storageService.delete("notification_serial_id");
        await storageService.delete("notification_schedule");
      } else {
        statusMessage.value = 'splash_please_login'.tr;
        await Future.delayed(const Duration(milliseconds: 300));
        final isFirstTime = await storageService.readBool("is_first_time");
        if (isFirstTime == null || isFirstTime == true) {
          storageService.writeBool("is_first_time", false);
          Get.offAllNamed(RouteNames.onboardingPage);
        } else {
          Get.offAllNamed(RouteNames.loginPage);
        }
      }
    } catch (e) {
      statusMessage.value = '${"error".tr}: ${e.toString()}';
      await Future.delayed(const Duration(milliseconds: 500));
      _showRetryDialog();
    }
  }

  /// Shows a retry dialog for connection issues.
  /// Allows user to retry initialization.
  void _showRetryDialog() {
    Get.defaultDialog(
      title: "splash_error_dialog_title".tr,
      middleText: "splash_error_dialog_message".tr,
      textConfirm: "splash_error_dialog_retry".tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        _initializeApp(); // Coba inisialisasi ulang
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            const CustomIcon(type: MyCustomIcon.logoWhite, size: 100),
            SizedBox(height: 24.h),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16.h),

            // Status message
            Obx(
              () => Text(
                statusMessage.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
