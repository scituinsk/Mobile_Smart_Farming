import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/features/notification/presentation/screens/notification_screen.dart';
import 'package:pak_tani/src/features/selenoid/presentation/screens/selenoid_screen.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteNamed.notificationPage,
      page: () => const NotificationScreen(),
    ),
    GetPage(name: RouteNamed.selenoidPage, page: () => const SelenoidScreen()),
  ];
}
