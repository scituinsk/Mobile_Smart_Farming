import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';
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
    tabController = TabController(length: 3, vsync: this);
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
        _initializeModulTab();
        break;
      case 1: // history
        _initializeHistoryTab();
        break;
      case 2: // profile
        _initializeProfileTab();
        break;
    }

    _initializedTabs.add(index);
    _updateScreensList(); // ✅ Update screens list after initialization
    print("✅ Tab $index initialized");
  }

  // ✅ Update screens list and trigger GetBuilder update
  void _updateScreensList() {
    _screens = [_getScreen(0), _getScreen(1), _getScreen(2)];

    // ✅ Trigger GetBuilder rebuild
    update();
  }

  void _initializeModulTab() {
    if (!Get.isRegistered<ModulBinding>()) {
      ModulBinding().dependencies();
      print("inisialisasi modul binding");
    }

    _screensCache[0] = ModulsScreen();
  }

  void _initializeHistoryTab() {
    _screensCache[1] = Scaffold(
      appBar: AppBar(title: Text('History'), leading: SizedBox()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            Text('History Screen', style: Get.textTheme.headlineSmall),
            SizedBox(height: 20),
            Text('Coming soon....'),
          ],
        ),
      ),
    );
  }

  void _initializeProfileTab() {
    final AuthController authController = Get.find<AuthController>();

    _screensCache[2] = Scaffold(
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
            CircleAvatar(
              radius: 50,
              child: authController.currentUser.value!.image != null
                  ? Image.network(authController.currentUser.value!.image!)
                  : Icon(Icons.person, size: 55),
            ),
            SizedBox(height: 20),
            Text(
              authController.currentUser.value!.username,
              style: Get.textTheme.headlineSmall,
            ),
            SizedBox(height: 10),
            Text(authController.currentUser.value!.email),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async => await authController.logout(),
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
    if (index >= 0 && index < 3) {
      tabController.animateTo(index);
    }
  }

  void navigateToHome() => navigateToTab(0);
  void navigateToHistory() => navigateToTab(1);
  void navigateToProfile() => navigateToTab(2);

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
