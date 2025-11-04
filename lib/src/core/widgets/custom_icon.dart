import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MyCustomIcon {
  solenoid,
  greenHouse,
  waterPump,
  batteryMax,
  batteryLow,
  temprature,
  waterLevel,
  filter,
  waterPH,
  editPencil,
  logoPrimary,
  logoWhite,
  calendar,
}

String iconAssets(MyCustomIcon type) {
  switch (type) {
    case MyCustomIcon.solenoid:
      return "assets/icons/carbon-iot-platform.svg";
    case MyCustomIcon.greenHouse:
      return "assets/icons/mdi-greenhouse.svg";
    case MyCustomIcon.waterPump:
      return "assets/icons/material-symbols-water-pump.svg";
    case MyCustomIcon.batteryMax:
      return "assets/icons/fluent-battery-924-regular.svg";
    case MyCustomIcon.batteryLow:
      return "assets/icons/fluent-battery-432-regular.svg";
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
  }
}

class CustomIcon extends StatelessWidget {
  final MyCustomIcon type;
  final double size;
  final Color? color;
  const CustomIcon({super.key, required this.type, this.size = 28, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconAssets(type),
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
