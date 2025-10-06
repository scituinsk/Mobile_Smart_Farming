import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/presentation/splash_screen.dart';
import 'package:pak_tani/src/core/routes/app_page.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PAK Tani',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: SplashScreen(),
      getPages: AppPage.pages,
    );
  }
}
