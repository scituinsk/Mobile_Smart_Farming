/// Controller for main navigation.
/// Handle animation, tabController, Initialization of main tabs, Loading screen,
/// navigation function, and application life cycle

library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/config/firebase_cloud_messaging_config.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';
import 'package:pak_tani/src/features/history/application/services/history_service.dart';
import 'package:pak_tani/src/features/history/presentation/bindings/history_binding.dart';
import 'package:pak_tani/src/features/history/presentation/screens/history_screen.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/modul/presentation/bindings/modul_binding.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/moduls_screen.dart';

///Controller class for main navigation.
class MainNavigationController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  late AnimationController animationController;

  final RxInt currentPage = 0.obs;
  final RxDouble animationValue = 0.0.obs;

  /// Keep list of screens.
  /// Private variable that only used in this class.
  final List<Widget> _screens = [];

  /// Used for lazy initialize screen.
  /// Keep Map with int as screen index, and Widget as screen.
  final Map<int, Widget?> _screensCache = {};

  /// Keep initialized tabs, set is used to make sure tabs didn't duplicated.
  final Set<int> _initializedTabs = {};

  /// Getter for screens list.
  /// Used outside of this class
  List<Widget> get screens => _screens;

  @override
  void onInit() async {
    super.onInit();
    _initializeControllers();
    _initializeTab(0);
    _updateScreensList();
    await _registerFCM();
  }

  /// Register FCM life cycle.
  /// Ensures users send token and device info to server once they visit the main screen.
  Future<void> _registerFCM() async {
    final String? fcmToken = await FirebaseCloudMessagingConfig.getToken();
    if (fcmToken != null) {
      await FirebaseCloudMessagingConfig.sendTokenAndDeviceInfo(fcmToken);
    }
  }

  /// Initializes all controller used in this class
  /// Initialize TabController for tab, AnimationController for animation tab, listener to tabController animation,
  /// and listener when tab controller changing tab.
  void _initializeControllers() {
    tabController = TabController(length: 3, vsync: this);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // listen to animation controller, update animation value to tab controller animation value
    tabController.animation!.addListener(() {
      animationValue.value = tabController.animation!.value;
      update(['animation']);
    });

    //Listener when tab index changing
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        _initializeTab(tabController.index);
        _onTabChanged(tabController.index);
      }
    });

    print("✅ Main navigation controller initialized");
  }

  /// Initializes a tab based on its index.
  /// Occurs only once when tab is first visited.
  void _initializeTab(int index) {
    // if tabs alredy initialized, return this function.
    if (_initializedTabs.contains(index)) return;

    print("🔄 Initializing tab $index...");

    switch (index) {
      case 0:
        _initializeModulTab();
        break;
      case 1:
        _initializeHistoryTab();
        break;
      case 2:
        _initializeProfileTab();
        break;
    }

    // add initialized tab to this variable
    _initializedTabs.add(index);
    _updateScreensList();
    print("✅ Tab $index initialized");
  }

  /// Update the screens list and triggers GetBuilder rebuild.
  /// Used in _initializedTab and onInit.
  void _updateScreensList() {
    _screens.clear();
    _screens.addAll([_getScreen(0), _getScreen(1), _getScreen(2)]);
    update();
  }

  /// Initialized the modul tab/screen.
  /// Register modul binding if not alredy registered.
  void _initializeModulTab() {
    if (!Get.isRegistered<ModulBinding>()) {
      ModulBinding().dependencies();
      print("inisialisasi modul binding");
    }

    // load all moduls
    final modulService = Get.find<ModulService>();
    modulService.loadModuls();

    _screensCache[0] = ModulsScreen();
  }

  /// Initialize the history tab/screen.
  /// Register history binding if not alredy registered.
  void _initializeHistoryTab() {
    if (!Get.isRegistered<HistoryBinding>()) {
      HistoryBinding().dependencies();
      print("✅ init history binding");
    }
    _screensCache[1] = HistoryScreen();
  }

  /// Initialize the profile tab/screen
  /// haven't done yet
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
            SizedBox(height: 20.h),
            Text(
              authController.currentUser.value!.username,
              style: Get.textTheme.headlineSmall,
            ),
            SizedBox(height: 10.h),
            Text(authController.currentUser.value!.email),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () async => await authController.logout(),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets the screen widget for the given index.
  /// Returns a loading screen if not initialized.
  Widget _getScreen(int index) {
    if (!_initializedTabs.contains(index)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text('Loading...'),
          ],
        ),
      );
    }

    return _screensCache[index] ?? Center(child: Text('Screen not available'));
  }

  /// Handle tab change events.
  /// Update current page and loads tab lifecycle.
  void _onTabChanged(int index) {
    print("🔄 Tab changed to: $index");
    currentPage.value = index;
    final tabNames = ["Modul", "History", "Profile"];
    print("📊 User visited: ${tabNames[index]} tab");

    _loadTabLifeCycle(index);

    // Update GetBuilder for tab changes
    update();
  }

  /// Loads lifecycle for the visited tab.
  void _loadTabLifeCycle(int index) {
    switch (index) {
      case 0:
        final modulService = Get.find<ModulService>();
        modulService.loadModuls();
        break;
      case 1:
        final historyService = Get.find<HistoryService>();
        historyService.loadAllHistories();
        break;
    }
  }

  /// Navigates to the specified tab index.
  /// [index] must between 0 and 2
  void navigateToTab(int index) {
    if (index >= 0 && index < 3) {
      tabController.animateTo(index);
    }
  }

  /// Navigate to the modul tab.
  void navigateToModul() => navigateToTab(0);

  /// Navigate to the history tab.
  void navigateToHistory() => navigateToTab(1);

  /// Navigate to the profile tab.
  void navigateToProfile() => navigateToTab(2);

  /// Handle back button press.
  /// Prevents accidental app exit y navigating to the first tab or showing a dialog.
  Future<bool> onWillPop() async {
    final tabNames = ["Modul", "History", "Profile"];
    final currentTabName =
        (currentPage.value >= 0 && currentPage.value < tabNames.length)
        ? tabNames[currentPage.value]
        : 'Unknown';
    print('🔄 Back button pressed, current tab: $currentTabName');

    // If we're not on the first tab, go to first tab
    if (currentPage.value != 0) {
      print('🔄 Navigating to modul tab');
      navigateToModul();
      return false;
    }

    // Show exit confirmation dialog
    final shouldExit = await _showExitDialog();
    print('🔄 Should exit: $shouldExit');
    return shouldExit ?? false;
  }

  /// Shows an exit confirmation dialog.
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
