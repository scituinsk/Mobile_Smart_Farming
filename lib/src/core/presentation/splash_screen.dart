import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/services/connectivity_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RxString statusMessage = 'Initializing...'.obs;
  late StorageService storageService;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    storageService = Get.find<StorageService>();
  }

  Future<void> _initializeApp() async {
    try {
      statusMessage.value = "Memeriksa koneksi...";
      await Future.delayed(const Duration(milliseconds: 500));

      final connectivityService = Get.find<ConnectivityService>();
      await connectivityService.checkInitialConnection();

      if (!connectivityService.isConnected.value) {
        statusMessage.value = "Tidak ada koneksi internet!";
        _showRetryDialog();
        return;
      }

      statusMessage.value = 'Starting app...';

      statusMessage.value = "Getting auth service...";
      final authService = Get.find<AuthService>();
      authService.debugInfo();

      if (!authService.isReady) {
        print('❌ AuthService not ready, initializing...');
        // Force wait maksimal 3 detik
        int attempts = 0;
        while (!authService.isReady && attempts < 30) {
          await Future.delayed(Duration(milliseconds: 100));
          attempts++;
        }

        if (!authService.isReady) {
          throw Exception('AuthService failed to initialize');
        }
      }

      statusMessage.value = 'Checking authentication...';
      await authService.checkAuthenticationStatus();

      await Future.delayed(Duration(milliseconds: 500));

      //  Navigate based on auth status
      if (authService.isLoggedIn.value) {
        statusMessage.value = 'Welcome back!';
        await Future.delayed(Duration(milliseconds: 300));
        Get.offAllNamed(RouteNamed.mainPage);
      } else {
        statusMessage.value = 'Please login...';
        await Future.delayed(Duration(milliseconds: 300));
        // Get.offAllNamed(RouteNamed.loginPage);
        final isFirstTime = storageService.readBool("is_first_time");
        if (isFirstTime == null || isFirstTime == true) {
          storageService.writeBool("is_first_time", false);
          Get.offAllNamed(RouteNamed.onboardingPage);
        } else {
          Get.offAllNamed(RouteNamed.loginPage);
        }
      }
    } catch (e) {
      statusMessage.value = 'Error: ${e.toString()}';
      await Future.delayed(Duration(milliseconds: 500));
      _showRetryDialog();
    }
  }

  void _showRetryDialog() {
    Get.defaultDialog(
      title: "Koneksi Bermasalah",
      middleText:
          "Tidak dapat terhubung ke server. Pastikan Anda memiliki koneksi internet yang stabil.",
      textConfirm: "Coba Lagi",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Tutup dialog
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
            CustomIcon(type: MyCustomIcon.logoWhite, size: 100),
            SizedBox(height: 24.h),

            // Loading indicator
            CircularProgressIndicator(
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
