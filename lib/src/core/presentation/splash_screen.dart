import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      builder: (authController) {
        if (authController.isLoading.value) {
          return _buildLoadingScreen();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authController.isLoggedIn.value) {
            Get.offAllNamed(RouteNamed.mainPage);
          } else {
            Get.offAllNamed(RouteNamed.loginPage);
          }
        });

        return _buildLoadingScreen();
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Your app color
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

            // Loading text
            Text(
              'Pak Tani',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Loading...',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
