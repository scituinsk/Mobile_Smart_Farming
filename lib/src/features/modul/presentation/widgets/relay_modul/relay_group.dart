import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/relay_modul/relay_item.dart';

class RelayGroup extends StatelessWidget {
  final String title;
  const RelayGroup({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Grub: $title", style: AppTheme.h4),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: BoxBorder.all(color: AppTheme.titleSecondary, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 12,
            children: [
              RelayItem(
                customIcon: MyCustomIcon.lightBulb,
                title: "lampu",
                description: "sakelar untuk menyalakan lampu ata aasdf fads",
              ),
              RelayItem(
                customIcon: MyCustomIcon.waterDrop,
                title: "solenoid",
                description: "sakelar untuk menyalakan lampu ata aasdf fads",
                status: true,
              ),
              RelayItem(
                customIcon: MyCustomIcon.waterPump,
                title: "water pump",
                description: "sakelar untuk menyalakan lampu ata aasdf fads",
                status: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
