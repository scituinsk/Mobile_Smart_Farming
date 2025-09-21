import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/module/presentation/widgets/module_item.dart';

class ModulList extends StatelessWidget {
  const ModulList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 17,
        children: [
          Text("Daftar Modul", style: AppTheme.h5),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 60),
              itemCount: 3,
              itemBuilder: (context, index) => Column(
                children: [
                  ModuleItem(
                    title: "Green house A",
                    temprature: "16°C",
                    waterPH: "60.2%",
                    waterLevel: "83%",
                    waterPumpStatus: true,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
