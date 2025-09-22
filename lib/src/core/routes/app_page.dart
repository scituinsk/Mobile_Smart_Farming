import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/features/notification/presentation/screens/notification_screen.dart';
import 'package:pak_tani/src/features/scheduling/presentation/screens/scheduling_screen.dart';
import 'package:pak_tani/src/features/solenoid/presentation/screens/solenoid_screen.dart';

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
  ];
}
