/// Controller for main navigation.
/// Handle animation, tabController, Initialization of main tabs, Loading screen,
/// navigation function, and application life cycle

library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:pak_tani/src/core/config/firebase_cloud_messaging_config.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/core/utils/loading_dialog.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/history/presentation/bindings/history_binding.dart';
import 'package:pak_tani/src/features/history/presentation/controllers/history_controller.dart';
import 'package:pak_tani/src/features/history/presentation/screens/history_screen.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/presentation/bindings/modul_binding.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/moduls_screen.dart';
import 'package:pak_tani/src/features/notification/application/services/notification_service.dart';
import 'package:pak_tani/src/features/profile/application/services/profile_service.dart';
import 'package:pak_tani/src/features/profile/presentation/bindings/profile_bindings.dart';
import 'package:pak_tani/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:pak_tani/src/features/profile/presentation/screens/profile_screen.dart';

///Controller class for main navigation.
class MainNavigationController extends GetxController
    with GetTickerProviderStateMixin {
  final NotificationService _notificationService;
  final StorageService _storageService;
  MainNavigationController(this._notificationService, this._storageService);

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

  /// Argument Modul id
  Modul? modulIdArg;

  late Map<String, dynamic>? notificationArguments;

  RxInt get unreadNotificationCount => _notificationService.unreadCount;

  @override
  void onInit() async {
    super.onInit();
    notificationArguments = Get.arguments;
    _initializeControllers();
    _initializeTab(0);
    _updateScreensList();
    await _registerFCM();

    Future.delayed(Duration(seconds: 2), () => checkUpdateDaily());
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
  void _initializeModulTab() async {
    if (!Get.isRegistered<ModulBinding>()) {
      ModulBinding().dependencies();
      print("inisialisasi modul binding");
    }
    _screensCache[0] = ModulsScreen();

    // load all moduls
    print("load modul init");
    final modulService = Get.find<ModulService>();
    await modulService.loadModuls();
    if (notificationArguments != null) {
      print("notif argument: $notificationArguments");
      Get.toNamed(RouteNames.detailModulPage, arguments: notificationArguments);
    }
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
    if (!Get.isRegistered<ModulBinding>()) {
      ProfileBindings().dependencies();
      print("✅ init profile binding");
    }
    _screensCache[2] = ProfileScreen();
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
  void _loadTabLifeCycle(int index) async {
    switch (index) {
      case 0:
        FocusManager.instance.primaryFocus?.unfocus();

        print("load modul lifecycle");
        final modulService = Get.find<ModulService>();
        await modulService.loadModuls();
        break;
      case 1:
        FocusManager.instance.primaryFocus?.unfocus();

        final historyController = Get.find<HistoryController>();
        historyController.resetFilter();

        if (modulIdArg != null) {
          await historyController.refreshHistoryList(
            isNavigating: true,
            modulArgs: modulIdArg,
          );
          modulIdArg = null;
        } else {
          await historyController.refreshHistoryList();
        }

        break;
      case 2:
        FocusManager.instance.primaryFocus?.unfocus();

        final profileService = Get.find<ProfileService>();
        final profileController = Get.find<ProfileController>();
        LoadingDialog.show();
        await profileService.loadUserProfile();
        profileController.refreshTextControllerAndFocusNode();
        LoadingDialog.hide();
    }
  }

  /// Navigates to the specified tab index.
  /// [index] must between 0 and 2
  void navigateToTab(int index) {
    if (index >= 0 && index < 3) {
      _initializeTab(index);
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
    if (shouldExit == true) {
      SystemNavigator.pop();
      return false;
    }
    return false;
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

  Future<void> checkUpdateDaily() async {
    try {
      String todayDate = DateTime.now().toIso8601String().split("T")[0];
      String? lastCheckedDate = await _storageService.read("last_checked_date");

      if (todayDate == lastCheckedDate) {
        return;
      }

      await _performUpdateCheck();

      await _storageService.write("last_checked_date", todayDate);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> _performUpdateCheck() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onClose() {
    print('🔄 MainNavigationController disposing...');
    tabController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
