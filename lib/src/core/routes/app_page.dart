/// App page routes.
/// Defines all application routes using GetX GetPage for navigation.

library;

import 'package:get/get.dart';
import 'package:pak_tani/src/core/navigation/main_navigation.dart';
import 'package:pak_tani/src/core/navigation/main_navigation_binding.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/features/auth/presentation/screens/terms_screen.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/qr_code_screen.dart';
import 'package:pak_tani/src/features/notification/presentation/bindings/notification_bindings.dart';
import 'package:pak_tani/src/features/onboarding/presentation/bindings/onboard_screen_binding.dart';
import 'package:pak_tani/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:pak_tani/src/features/schedule/presentation/bindings/schedule_screen_binding.dart';
import 'package:pak_tani/src/features/modul/presentation/bindings/add_modul_screen_binding.dart';
import 'package:pak_tani/src/features/modul/presentation/bindings/modul_detail_screen_binding.dart';
import 'package:pak_tani/src/features/modul/presentation/bindings/qr_scan_screen_binding.dart';
import 'package:pak_tani/src/features/relays/presentation/bindings/relay_binding.dart';
import 'package:pak_tani/src/features/relays/presentation/bindings/relay_screen_binding.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/add_modul_screen.dart';
import 'package:pak_tani/src/features/auth/presentation/screens/login_screen.dart';
import 'package:pak_tani/src/features/auth/presentation/screens/register_screen.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/modul_detail_screen.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/qr_scann_screen.dart';
import 'package:pak_tani/src/features/relays/presentation/screens/relay_screen.dart';
import 'package:pak_tani/src/features/notification/presentation/screens/notification_screen.dart';
import 'package:pak_tani/src/features/schedule/presentation/screens/group_schedule_screen.dart';

///App page class.
///Contains all route definition for the application
class AppPage {
  /// List of all application pages/routes
  /// Each GetPage defines a route name, page widget, and optional binding.
  static final pages = [
    // Notification page
    GetPage(
      name: RouteNames.notificationPage,
      page: () => const NotificationScreen(),
      binding: NotificationBindings(),
    ),
    // Group schedule page
    GetPage(
      name: RouteNames.groupSchedulePage,
      page: () => const ScheduleScreen(),
      binding: ScheduleScreenBinding(),
    ),

    // add modul page
    GetPage(
      name: RouteNames.addModulPage,
      page: () => const AddModulScreen(),
      binding: AddModulScreenBinding(),
    ),

    // detail modul page
    GetPage(
      name: RouteNames.detailModulPage,
      page: () => const ModulDetailScreen(),
      bindings: [RelayBinding(), ModulDetailScreenBinding()],
    ),

    // login page
    GetPage(name: RouteNames.loginPage, page: () => const LoginScreen()),

    // register page
    GetPage(name: RouteNames.registerPage, page: () => const RegisterScreen()),

    // main navigation page
    GetPage(
      name: RouteNames.mainPage,
      page: () => MainNavigation(),
      binding: MainNavigationBinding(),
    ),

    // qr scan page
    GetPage(
      name: RouteNames.qrScanPage,
      page: () => const QrScannScreen(),
      binding: QrScanScreenBinding(),
    ),

    // list of relays page
    GetPage(
      name: RouteNames.relayPage,
      page: () => RelayScreen(),
      binding: RelayScreenBinding(),
    ),

    // modul serial id qr code page
    GetPage(name: RouteNames.qrCodePage, page: () => QrCodeScreen()),

    // on boarding page
    GetPage(
      name: RouteNames.onboardingPage,
      page: () => OnboardingScreen(),
      binding: OnboardScreenBinding(),
    ),
    GetPage(name: RouteNames.termsPage, page: () => TermsScreen()),
  ];
}
