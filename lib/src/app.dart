import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/presentation/splash_screen.dart';
import 'package:pak_tani/src/core/routes/app_page.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/translations/app_translations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.42857142857144, 914.2857142857143),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'PAK Tani',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          themeMode: ThemeMode.light,
          translations: AppTranslations(),
          locale: Get.deviceLocale,
          fallbackLocale: Locale('id', 'ID'),
          home: child,
          getPages: AppPage.pages,
          defaultTransition: Transition.cupertino,
          transitionDuration: Duration(milliseconds: 300),
          enableLog: true,
        );
      },
      child: SplashScreen(),
    );
  }
}
