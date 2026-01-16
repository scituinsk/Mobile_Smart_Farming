/// Main Navigation screen.
/// Display a floating bottom bar with animated tabs for modul, history, and profile.
/// Users TabBarView for screen switching and handles back button for navigation or exit.

library;

import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/controllers/main_navigation_controller.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

/// Main navigation screen widget.
/// Integrate with MainNavigationController for tab management and animation.
class MainNavigation extends GetView<MainNavigationController> {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainNavigationController>(
      builder: (controller) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            final shouldPop = await controller.onWillPop();
            if (shouldPop && context.mounted) {
              Navigator.of(context).pop(result);
            }
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BottomBar(
            fit: StackFit.expand,
            icon: (width, height) => Center(
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: null,
                icon: Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.grey,
                  size: width,
                ),
              ),
            ),
            borderRadius: BorderRadius.circular(500),
            duration: Duration(milliseconds: 500),
            curve: Curves.decelerate,
            showIcon: true,
            width: MediaQuery.of(context).size.width * 0.8,
            barColor: Colors.white,
            start: 2,
            end: 0,
            offset: 10,
            barAlignment: Alignment.bottomCenter,
            iconHeight: 35,
            iconWidth: 35,
            reverse: false,
            iconDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(500.r),
            ),
            hideOnScroll: false,
            scrollOpposite: false,
            body: (context, scrollController) => TabBarView(
              controller: controller.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: controller.screens,
            ),
            child: SizedBox(
              height: 60,
              // Replace Obx with GetBuilder for animation
              child: GetBuilder<MainNavigationController>(
                id: 'animation', // Specific ID for animation updates
                builder: (controller) => Stack(
                  children: [
                    Positioned(
                      left:
                          controller.animationValue.value *
                              (MediaQuery.of(context).size.width * 0.8 / 3) +
                          //(0.8 / jumlah tab), jika 3 maka 3, jika maka 4
                          (MediaQuery.of(context).size.width * 0.8 / 3 - 50) /
                              2,
                      top: 5,
                      child: AnimatedContainer(
                        duration: Duration.zero,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.secondaryColor.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Tab Bar
                    TabBar(
                      controller: controller.tabController,
                      tabs: [
                        _buildCustomTab(Icons.dashboard, 0, controller),
                        _buildCustomTab(Icons.history, 1, controller),
                        _buildCustomTab(
                          Icons.person_outline_rounded,
                          2,
                          controller,
                        ),
                      ],
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a custom tab with animated icon color.
  /// [icon] is the icon to display, [index] is the tab index, [controller] is the navigation controller.
  /// Returns a SizedBox with centered animated icon.
  Widget _buildCustomTab(
    IconData icon,
    int index,
    MainNavigationController controller,
  ) {
    return GetBuilder<MainNavigationController>(
      id: 'animation',
      builder: (controller) {
        double distance = (controller.animationValue.value - index).abs();
        bool isTransitioning = distance <= 1.0;

        Color iconColor;
        if (!isTransitioning) {
          iconColor = Colors.grey;
        } else {
          double opacity = 1.0 - distance;
          iconColor =
              Color.lerp(Colors.grey, Colors.white, opacity) ?? Colors.grey;
        }

        return SizedBox(
          height: 60,
          child: Center(child: Icon(icon, color: iconColor, size: 28)),
        );
      },
    );
  }
}
