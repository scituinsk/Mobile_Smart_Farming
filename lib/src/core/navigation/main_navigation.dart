import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/home/presentation/screens/home_screen.dart';
import 'package:pak_tani/src/features/module/presentation/screen/module_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  late TabController tabController;
  late AnimationController animationController;
  int currentPage = 0;
  double animationValue = 0.0;

  final List<Widget> screens = [
    HomeScreen(),
    ModuleScreen(), // TODO: buat screen ini
    Center(child: Text('history screen')), // TODO: buat screen ini
    Center(child: Text('Profile Screen')), // TODO: buat screen ini
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    tabController.animation!.addListener(() {
      if (mounted) {
        setState(() {
          animationValue = tabController.animation!.value;
          currentPage = animationValue
              .round(); // Gunakan round() untuk realtime update
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          borderRadius: BorderRadius.circular(500),
        ),

        hideOnScroll: false,
        scrollOpposite: false,

        body: (context, controller) => TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(),
          children: screens,
        ),
        child: Container(
          height: 60,
          child: Stack(
            children: [
              // Animated indicator
              Positioned(
                left:
                    animationValue *
                        (MediaQuery.of(context).size.width * 0.8 / 4) +
                    (MediaQuery.of(context).size.width * 0.8 / 4 - 50) / 2,
                top: 5,
                child: AnimatedContainer(
                  duration: Duration.zero,
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              // Tab Bar
              TabBar(
                controller: tabController,
                tabs: [
                  _buildCustomTab(Icons.home, 0),
                  _buildCustomTab(Icons.view_comfy_sharp, 1),
                  _buildCustomTab(Icons.access_time, 2),
                  _buildCustomTab(Icons.person_rounded, 3),
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
    );
  }

  Widget _buildCustomTab(IconData icon, int index) {
    double distance = (animationValue - index).abs();
    bool isTransitioning = distance <= 1.0; // Hanya tab yang sedang transisi

    Color iconColor;
    if (!isTransitioning) {
      // Tab yang tidak sedang transisi tetap grey
      iconColor = Colors.grey;
    } else {
      // Hanya tab yang sedang transisi yang beranimasi
      double opacity = 1.0 - distance;
      iconColor = Color.lerp(Colors.grey, Colors.white, opacity) ?? Colors.grey;
    }

    return Container(
      height: 60,
      child: Center(child: Icon(icon, color: iconColor, size: 28)),
    );
  }
}
