import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/widgets/solenoid_widgets/selenoid_item.dart';

class SolenoidList extends StatelessWidget {
  const SolenoidList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("Status Relay", style: AppTheme.h4),
        SizedBox(
          height: 170,
          child: MasonryGridView.builder(
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SolenoidItem(
                  title: "Solenoid mas sani ahh",
                  status: index % 2 == 0 ? true : false,
                );
              }
              return SolenoidItem(
                title: "Solenoid ${index + 1}",
                status: index % 2 == 0 ? true : false,
              );
            },
          ),
        ),
      ],
    );
  }
}
