import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/home/presentation/widgets/home_module_item.dart';

class HomeModuleList extends StatelessWidget {
  const HomeModuleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text("Ringkasan Modul", style: AppTheme.h3),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 60),
              itemCount: 3,
              itemBuilder: (context, index) => Column(
                children: [
                  HomeModuleItem(
                    waterpumpStatus: false,
                    name: "Green Housse A",
                  ),
                  SizedBox(height: 16), // Jarak antar children
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
