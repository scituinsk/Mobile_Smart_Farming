import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/di/dependency_injection.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RxString statusMessage = 'Initializing...'.obs;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      statusMessage.value = 'Starting app...';
      print('🚀 Splash: Starting app initialization...');

      // ✅ Wait for all dependencies with timeout
      statusMessage.value = 'Loading dependencies...';
      bool isReady = await DependencyInjection.waitUntilReady(
        timeout: Duration(seconds: 15),
      );

      if (!isReady) {
        throw Exception('❌ Dependencies initialization timeout');
      }

      statusMessage.value = 'Checking authentication...';
      print('✅ Splash: Dependencies ready, checking auth status...');

      // ✅ Get AuthService
      final authService = Get.find<AuthService>();

      // ✅ Wait a bit to ensure UI is ready
      await Future.delayed(Duration(milliseconds: 500));

      // ✅ Navigate based on auth status
      if (authService.isLoggedIn.value) {
        print('👤 Splash: User is logged in, navigating to main...');
        statusMessage.value = 'Welcome back!';
        await Future.delayed(Duration(milliseconds: 300));
        Get.offAllNamed(RouteNamed.mainPage);
      } else {
        print('🔐 Splash: User not logged in, navigating to auth...');
        statusMessage.value = 'Please login...';
        await Future.delayed(Duration(milliseconds: 300));
        Get.offAllNamed(RouteNamed.loginPage);
      }
    } catch (e) {
      print('❌ Splash initialization error: $e');
      statusMessage.value = 'Error occurred, redirecting...';
      await Future.delayed(Duration(milliseconds: 500));
      // ✅ Always fallback to auth screen on error
      Get.offAllNamed(RouteNamed.loginPage);
    }
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
            SizedBox(height: 24),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),

            // Status message
            Obx(
              () => Text(
                statusMessage.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
