import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
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
        Get.offAllNamed(RouteNamed.loginPage);
      }
    } catch (e) {
      statusMessage.value = 'Error occurred, redirecting...';
      await Future.delayed(Duration(milliseconds: 500));
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
