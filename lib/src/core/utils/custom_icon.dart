import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Enum representing various custom icon types used in the app.
/// Each value corresponds to a specific SVG asset.
enum MyCustomIcon {
  solenoid,
  greenHouse,
  waterPump,

  temprature,
  waterLevel,
  filter,
  waterPH,
  editPencil,
  logoPrimary,
  logoWhite,
  calendar,
  lightBulb,
  waterDrop,
  search,
  calendarSync,
  server,
  instagram,
  whatsapp,
  gmail,
  notifEmpty,
  modulEmpty,
  battery_0,
  battery_1,
  battery_2,
  battery_3,
  battery_4,
}

/// Returns the asset path for the given custom icon type.
///
/// This function maps each [MyCustomIcon] to its corresponding SVG file path.
String iconAssets(MyCustomIcon type) {
  switch (type) {
    case MyCustomIcon.solenoid:
      return "assets/icons/carbon-iot-platform.svg";
    case MyCustomIcon.greenHouse:
      return "assets/icons/mdi-greenhouse.svg";
    case MyCustomIcon.waterPump:
      return "assets/icons/material-symbols-water-pump.svg";
    case MyCustomIcon.battery_0:
      return "assets/icons/battery_0.svg";
    case MyCustomIcon.battery_1:
      return "assets/icons/battery_1.svg";
    case MyCustomIcon.battery_2:
      return "assets/icons/battery_2.svg";
    case MyCustomIcon.battery_3:
      return "assets/icons/battery_3.svg";
    case MyCustomIcon.battery_4:
      return "assets/icons/battery_4.svg";
    case MyCustomIcon.temprature:
      return "assets/icons/oui-temperature.svg";
    case MyCustomIcon.waterLevel:
      return "assets/icons/solar-water-broken.svg";
    case MyCustomIcon.waterPH:
      return "assets/icons/material-symbols-light-water-ph-sharp.svg";
    case MyCustomIcon.filter:
      return "assets/icons/filter.svg";
    case MyCustomIcon.editPencil:
      return "assets/icons/edit-pencil.svg";
    case MyCustomIcon.calendar:
      return "assets/icons/calendar.svg";
    case MyCustomIcon.logoPrimary:
      return "assets/logo/logo_primary.svg";
    case MyCustomIcon.logoWhite:
      return "assets/logo/logo_white.svg";
    case MyCustomIcon.lightBulb:
      return "assets/icons/lightbulb.svg";
    case MyCustomIcon.waterDrop:
      return "assets/icons/water_drop.svg";
    case MyCustomIcon.search:
      return "assets/icons/iconamoon-search.svg";
    case MyCustomIcon.calendarSync:
      return "assets/icons/calendar-sync.svg";
    case MyCustomIcon.server:
      return "assets/icons/server.svg";
    case MyCustomIcon.instagram:
      return "assets/icons/instagram_logo.svg";
    case MyCustomIcon.modulEmpty:
      return "assets/svgs/modul_empty.svg";
    case MyCustomIcon.notifEmpty:
      return "assets/svgs/notif_empty.svg";

    case MyCustomIcon.whatsapp:
      return "assets/icons/whatsapp_logo.svg";
    case MyCustomIcon.gmail:
      return "assets/icons/gmail_logo.svg";
  }
}

/// A stateless widget for displaying custom SVG icons.
///
/// This widget renders an SVG icon based on the provided [type], with optional [size] and [color].
class CustomIcon extends StatelessWidget {
  final MyCustomIcon type;
  final double size;
  final Color? color;
  const CustomIcon({super.key, required this.type, this.size = 28, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconAssets(type),
      width: size.w,
      height: size.h,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
