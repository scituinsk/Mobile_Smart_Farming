import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/home/presentation/screens/home_screen.dart';
import 'package:pak_tani/src/features/modul/presentation/bindings/modul_binding.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/moduls_screen.dart';

class MainNavigationController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  late AnimationController animationController;

  final RxInt currentPage = 0.obs;
  final RxDouble animationValue = 0.0.obs;
  final RxBool isInitialized = false.obs;

  // ✅ Use regular List for screens (not observable)
  List<Widget> _screens = [];

  // lazy loaded screens
  final Map<int, Widget?> _screensCache = {};
  final Set<int> _initializedTabs = {};

  // ✅ Getter for screens
  List<Widget> get screens => _screens;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _initializeTab(0);
    _updateScreensList(); // ✅ Initialize screens list
  }

  void _initializeControllers() {
    tabController = TabController(length: 4, vsync: this);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // ✅ Add animation listener for smooth indicator
    tabController.animation!.addListener(() {
      animationValue.value = tabController.animation!.value;
      // ✅ Update GetBuilder with specific ID
      update(['animation']);
    });

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        _initializeTab(tabController.index);
        _onTabChanged(tabController.index);
      }
    });

    isInitialized.value = true;
    print("✅ Main navigation controller initialized");
  }

  void _initializeTab(int index) {
    if (_initializedTabs.contains(index)) return;

    print("🔄 Initializing tab $index...");

    switch (index) {
      case 0: // home
        _initializeHomeTab();
        break;
      case 1: // modul
        _initializeModulTab();
        break;
      case 2: // history
        _initializeHistoryTab();
        break;
      case 3: // profile
        _initializeProfileTab();
        break;
    }

    _initializedTabs.add(index);
    _updateScreensList(); // ✅ Update screens list after initialization
    print("✅ Tab $index initialized");
  }

  // ✅ Update screens list and trigger GetBuilder update
  void _updateScreensList() {
    _screens = [_getScreen(0), _getScreen(1), _getScreen(2), _getScreen(3)];

    // ✅ Trigger GetBuilder rebuild
    update();
  }

  void _initializeHomeTab() {
    _screensCache[0] = HomeScreen();
  }

  void _initializeModulTab() {
    if (!Get.isRegistered<ModulBinding>()) {
      ModulBinding().dependencies();
      print("inisialisasi modul binding");
    }

    _screensCache[1] = ModulsScreen();
  }

  void _initializeHistoryTab() {
    _screensCache[2] = Scaffold(
      appBar: AppBar(title: Text('History'), leading: SizedBox()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            Text('History Screen', style: Get.textTheme.headlineSmall),
            SizedBox(height: 20),
            Text('Your activity history will appear here'),
          ],
        ),
      ),
    );
  }

  void _initializeProfileTab() {
    _screensCache[3] = Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: SizedBox(),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Get.snackbar('Info', 'Settings coming soon!'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            SizedBox(height: 20),
            Text('John Doe', style: Get.textTheme.headlineSmall),
            SizedBox(height: 10),
            Text('john.doe@example.com'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.snackbar('Info', 'Settings coming soon!'),
              child: Text('Settings'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () =>
                  Get.snackbar('Info', 'Logout functionality coming soon!'),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getScreen(int index) {
    if (!_initializedTabs.contains(index)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      );
    }

    return _screensCache[index] ?? Center(child: Text('Screen not available'));
  }

  void _onTabChanged(int index) {
    print("🔄 Tab changed to: $index");
    currentPage.value = index;
    _trackTabVisit(index);

    // ✅ Update GetBuilder for tab changes
    update();
  }

  void _trackTabVisit(int index) {
    final tabNames = ["Home", "Modul", "History", "Profile"];
    print("📊 User visited: ${tabNames[index]} tab");
  }

  void navigateToTab(int index) {
    if (index >= 0 && index < 4) {
      tabController.animateTo(index);
    }
  }

  void navigateToHome() => navigateToTab(0);
  void navigateToModul() => navigateToTab(1);
  void navigateToHistory() => navigateToTab(2);
  void navigateToProfile() => navigateToTab(3);

  Future<bool> onWillPop() async {
    final tabNames = ["Home", "Modul", "History", "Profile"];
    final currentTabName =
        (currentPage.value >= 0 && currentPage.value < tabNames.length)
        ? tabNames[currentPage.value]
        : 'Unknown';
    print('🔄 Back button pressed, current tab: $currentTabName');

    // If we're not on the first tab, go to first tab
    if (currentPage.value != 0) {
      print('🔄 Navigating to home tab');
      navigateToHome();
      return false; // Don't exit app
    }

    // Show exit confirmation dialog
    final shouldExit = await _showExitDialog();
    print('🔄 Should exit: $shouldExit');
    return shouldExit ?? false;
  }

  Future<bool?> _showExitDialog() {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text('Exit App'),
        content: Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Exit'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    print('🔄 MainNavigationController disposing...');
    tabController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
