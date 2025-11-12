import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/relay_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/relay_modul/relay_add_modal.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/relay_modul/relay_item.dart';

class RelayScreen extends StatelessWidget {
  const RelayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RelayController>();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 25),
            child: MyBackButton(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(() {
            final groups = controller.groupsRelay;

            if (groups.isEmpty) {
              return Center(
                child: Text('No groups', style: TextStyle(color: Colors.grey)),
              );
            }
            final lists = List.generate(groups.length, (listIndex) {
              final group = groups[listIndex];
              final items = (group.relays ?? <Relay>[])
                  .map(
                    (r) => DragAndDropItem(
                      child: RelayItem(
                        customIcon: MyCustomIcon.waterDrop,
                        title: r.name,
                        description: "pin ${r.pin}",
                      ),
                    ),
                  )
                  .toList();

              return DragAndDropList(
                header: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("Grub: ${group.name}", style: AppTheme.h4),
                ),
                children: items,
              );
            });

            return DragAndDropLists(
              children: lists,
              onItemReorder:
                  (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
                    controller.moveRelayWithIndices(
                      oldListIndex,
                      oldItemIndex,
                      newListIndex,
                      newItemIndex,
                    );
                  },
              onListReorder: (oldListIndex, newListIndex) {
                final List<GroupRelay> copied = List.from(groups);
                final moved = copied.removeAt(oldListIndex);
                copied.insert(newListIndex, moved);
                controller.groupsRelay.assignAll(copied);
              },
              listPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              listInnerDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              lastItemTargetHeight: 8,
              addLastItemTargetHeightToTop: true,
              lastListTargetSize: 40,
            );

            // final itemCount = groups.length;
            // if (itemCount == 0) {
            //   return Center(
            //     child: Text('No groups', style: TextStyle(color: Colors.grey)),
            //   );
            // }
            // return ListView.builder(
            //   itemCount: itemCount,
            //   itemBuilder: (context, index) {
            //     final group = groups[index];
            //     return RelayGroup(
            //       relays: group.relays ?? <Relay>[],
            //       groupName: group.name,
            //     );
            //   },
            // );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RelayAddModal.show(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
