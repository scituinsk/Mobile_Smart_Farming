import 'package:get/get.dart';
import 'package:pak_tani/src/core/navigation/main_navigation.dart';
import 'package:pak_tani/src/core/navigation/main_navigation_binding.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
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

class AppPage {
  static final pages = [
    GetPage(
      name: RouteNamed.notificationPage,
      page: () => const NotificationScreen(),
    ),
    GetPage(
      name: RouteNamed.groupSchedulePage,
      page: () => const ScheduleScreen(),
      binding: ScheduleScreenBinding(),
    ),

    GetPage(
      name: RouteNamed.addModulPage,
      page: () => const AddModulScreen(),
      binding: AddModulScreenBinding(),
    ),
    GetPage(
      name: RouteNamed.detailModulPage,
      page: () => const ModulDetailScreen(),
      bindings: [RelayBinding(), ModulDetailScreenBinding()],
    ),
    GetPage(name: RouteNamed.loginPage, page: () => const LoginScreen()),
    GetPage(name: RouteNamed.registerPage, page: () => const RegisterScreen()),
    GetPage(
      name: RouteNamed.mainPage,
      page: () => MainNavigation(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: RouteNamed.qrScanPage,
      page: () => const QrScannScreen(),
      binding: QrScanScreenBinding(),
    ),
    GetPage(
      name: RouteNamed.relayPage,
      page: () => const RelayScreen(),
      binding: RelayScreenBinding(),
    ),
  ];
}
