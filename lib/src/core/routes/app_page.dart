import 'package:get/get.dart';
import 'package:pak_tani/src/core/navigation/main_navigation.dart';
import 'package:pak_tani/src/core/navigation/main_navigation_binding.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/add_modul_screen.dart';
import 'package:pak_tani/src/features/auth/presentation/screens/login_screen.dart';
import 'package:pak_tani/src/features/auth/presentation/screens/register_screen.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/modul_detail_screen.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/qr_scann_screen.dart';
import 'package:pak_tani/src/features/modul/presentation/screen/relay_screen.dart';
import 'package:pak_tani/src/features/notification/presentation/screens/notification_screen.dart';
import 'package:pak_tani/src/features/scheduling/presentation/screens/scheduling_screen.dart';
import 'package:pak_tani/src/features/scheduling/presentation/screens/solenoid_screen.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteNamed.notificationPage,
      page: () => const NotificationScreen(),
    ),
    GetPage(name: RouteNamed.solenoidPage, page: () => const SolenoidScreen()),
    GetPage(
      name: RouteNamed.schedulingPage,
      page: () => const SchedulingScreen(),
    ),
    GetPage(name: RouteNamed.addModulPage, page: () => const AddModulScreen()),
    GetPage(
      name: RouteNamed.detailModulPage,
      page: () => const ModulDetailScreen(),
    ),
    GetPage(name: RouteNamed.loginPage, page: () => const LoginScreen()),
    GetPage(name: RouteNamed.registerPage, page: () => const RegisterScreen()),
    GetPage(
      name: RouteNamed.mainPage,
      page: () => MainNavigation(),
      binding: MainNavigationBinding(),
    ),
    GetPage(name: RouteNamed.qrScanPage, page: () => const QrScannScreen()),
    GetPage(name: RouteNamed.relayPage, page: () => const RelayScreen()),
  ];
}
