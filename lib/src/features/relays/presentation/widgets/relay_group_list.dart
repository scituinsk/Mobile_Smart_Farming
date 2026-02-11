import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';
import 'package:pak_tani/src/features/relays/presentation/controllers/relay_ui_controller.dart';
import 'package:pak_tani/src/features/relays/presentation/widgets/relay_item.dart';
import 'package:pak_tani/src/features/relays/presentation/widgets/relay_modals.dart';

class RelayGroupList extends StatelessWidget {
  RelayGroupList({super.key});

  final RelayUiController controller = Get.find<RelayUiController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Obx(() {
        final groups = controller.relayGroups;
        final unassignedRelays = controller.relayService.getUnassignedRelays();

        final lists = <DragAndDropList>[];

        // ✅ Unassigned relays list (index 0)
        if (unassignedRelays.isNotEmpty) {
          final unassignedItems = unassignedRelays
              .map(
                (r) => DragAndDropItem(
                  child: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Obx(
                      () => RelayItem(
                        relay: r,
                        isEditMode: controller.isEditingRelay.value,
                      ),
                    ),
                  ),
                ),
              )
              .toList();

          lists.add(
            DragAndDropList(
              header: Padding(
                padding: EdgeInsets.all(8.0.r),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.inbox,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "relay_ungrouped_title".tr,
                      style: AppTheme.h4.copyWith(
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              canDrag: false,
              children: unassignedItems,
            ),
          );
        }

        // ✅ Relay groups (index 1+)
        lists.addAll(
          List.generate(groups.length, (index) {
            final group = groups[index];
            final items = (group.relays ?? <Relay>[])
                .map(
                  (r) => DragAndDropItem(
                    child: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: Obx(
                        () => RelayItem(
                          relay: r,
                          isEditMode: controller.isEditingRelay.value,
                        ),
                      ),
                    ),
                  ),
                )
                .toList();

            // Jika tidak ada relay, tambahkan placeholder
            if (items.isEmpty) {
              items.add(
                DragAndDropItem(
                  canDrag: false, // Placeholder tidak bisa di-drag
                  child: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.blocks,
                            size: 32,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'relay_group_empty'.tr,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return DragAndDropList(
              header: Padding(
                padding: EdgeInsets.all(8.0.r),
                child: Obx(
                  () => Row(
                    spacing: 20.r,
                    children: [
                      Text(
                        "${"relay_group_label".tr}: ${group.name}",
                        style: AppTheme.h4,
                      ),
                      if (controller.isEditingGroup.value)
                        MyIcon(
                          icon: Icons.edit_outlined,
                          onPressed: () {
                            RelayModals.showEditGroupModal(context, group);
                          },
                          backgroundColor: AppTheme.primaryColor,
                          iconColor: Colors.white,
                          iconSize: 19,
                          padding: 5,
                        ),
                      if (controller.isEditingGroup.value)
                        MyIcon(
                          icon: Icons.delete,
                          onPressed: () {
                            RelayModals.showDeleteGroupModal(context, group.id);
                          },
                          backgroundColor: AppTheme.errorColor,
                          iconColor: Colors.white,
                          iconSize: 19,
                          padding: 5,
                        ),
                    ],
                  ),
                ),
              ),
              canDrag: false,
              children: items,
            );
          }),
        );

        // Empty state
        if (lists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.blocks, size: 64, color: Colors.grey.shade300),
                SizedBox(height: 16.h),
                Text(
                  'relay_list_empty'.tr,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return Obx(
          () => RefreshIndicator(
            onRefresh: () async => await controller.handleReloadRelays(),
            child: DragAndDropLists(
              children: lists,
              itemDragOnLongPress: false,

              itemDragHandle: !controller.isEditingRelay.value
                  ? DragHandle(
                      verticalAlignment: DragHandleVerticalAlignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(right: 23.w),
                        child: Icon(
                          LucideIcons.menu,
                          color: Colors.black,
                          size: 20.r,
                        ),
                      ),
                    )
                  : null,
              onItemReorder:
                  (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
                    if (newListIndex == 0 && oldListIndex != 0) {
                      LogUtils.d("Cannot move relay from group to unassigned");
                      MySnackbar.warning(message: "relay_must_be_in_group".tr);
                      return;
                    }

                    controller.moveRelayWithIndices(
                      oldListIndex,
                      oldItemIndex,
                      newListIndex,
                      newItemIndex,
                    );
                  },
              onListReorder: (oldListIndex, newListIndex) {
                final hasUnassignedList = unassignedRelays.isNotEmpty;

                // ✅ Skip if trying to reorder unassigned list
                if (oldListIndex == 0 || newListIndex == 0) {
                  LogUtils.d("Cannot reorder unassigned list");
                  return;
                }

                final List<RelayGroup> copied = List.from(groups);

                // ✅ Adjust indices (karena unassigned ada di index 0)
                final adjustedOld = hasUnassignedList
                    ? oldListIndex - 1
                    : oldListIndex;
                final adjustedNew = hasUnassignedList
                    ? newListIndex - 1
                    : newListIndex;

                final moved = copied.removeAt(adjustedOld);
                copied.insert(adjustedNew, moved);
                controller.relayGroups.assignAll(copied);

                LogUtils.d("Reordered groups:  → ");
              },
              listPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.h),
              listInnerDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              lastItemTargetHeight: 8.h,
              addLastItemTargetHeightToTop: true,
              lastListTargetSize: 40,
            ),
          ),
        );
      }),
    );
  }
}
