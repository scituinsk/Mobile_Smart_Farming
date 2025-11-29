import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/solenoid_widgets/selenoid_item.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';

class SolenoidList extends StatelessWidget {
  const SolenoidList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleUiController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("Status Relay", style: AppTheme.h4),
        Obx(() {
          final List<Relay> selectedGroupRelay =
              controller.selectedRelayGroup.value!.relays ?? [];

          print("jumlah relay: ${selectedGroupRelay.length}");

          final isTwoRow = selectedGroupRelay.length > 3;

          return SizedBox(
            height: isTwoRow ? 170 : 80,
            child: MasonryGridView.builder(
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTwoRow ? 2 : 1,
              ),
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              scrollDirection: Axis.horizontal,
              itemCount: selectedGroupRelay.length,
              itemBuilder: (context, index) {
                final relay = selectedGroupRelay[index];
                return SolenoidItem(title: relay.name, status: relay.status);
              },
            ),
          );
        }),
      ],
    );
  }
}
