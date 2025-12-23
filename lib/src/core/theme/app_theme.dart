import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static const primaryColor = Color(0xff326765);
  static const secondaryColor = Color(0xff3288C6);
  static const ternaryColor = Color(0xff97008B);
  static const surfaceColor = Color(0xffF3F5F7);
  static const errorColor = Color(0xffC70000);
  // static const sucessColor = Color(0xff298267);
  // static const defaultColor = Color(0xffE8E9F1);
  static const onDefaultColor = Color(0xff7C7C7C);

  // static const iconColor = Color(0xff2897FF);

  static const textColor = Color(0xff000000);
  static const titleSecondary = Color(0xff7C7C7C);
  // static const defaultTextColor = Color(0xff8F9098);

  static const solenoidColor = Color(0xffFFAAF8);
  static const waterPumpColor = Color(0xff9AD16D);

  static const humidityColor = Color(0xff158694);
  static const temperatureColor = Color(0xffBD0D00);
  static const waterLevelColor = Color(0xff0055A5);

  static final h5 = TextStyle(
    color: textColor,

    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  static final h4 = TextStyle(
    color: textColor,

    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static final h3 = TextStyle(
    color: textColor,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );

  static final h2SemiBold = TextStyle(
    color: textColor,
    fontFamily: 'Clash Display',
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static final h2 = TextStyle(
    color: textColor,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static final h2Medium = TextStyle(
    color: textColor,
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
  );

  static final h1 = TextStyle(
    color: textColor,
    fontFamily: 'Clash Display',
    fontSize: 37.sp,
    fontWeight: FontWeight.bold,
  );

  static final h1Rubik = TextStyle(
    color: textColor,
    fontSize: 37.sp,
    fontWeight: FontWeight.normal,
  );

  static final largeTimeText = TextStyle(
    color: primaryColor,
    fontSize: 60.sp,
    fontWeight: FontWeight.w500,
  );

  static final textAction = TextStyle(
    color: onDefaultColor,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static final textDefault = TextStyle(
    color: onDefaultColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static final text = TextStyle(
    color: textColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static final textMedium = TextStyle(
    color: textColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  static final textSmall = TextStyle(
    color: textColor,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  static final textSmallMedium = TextStyle(
    color: textColor,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );

  static ThemeData light = ThemeData(
    // useMaterial3: true,
    textTheme: GoogleFonts.rubikTextTheme(),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      tertiary: waterPumpColor,
      onTertiary: textColor,
      error: errorColor,
      onError: Colors.white,
      surface: surfaceColor,
      onSurface: Colors.black,
    ),
  );
}
