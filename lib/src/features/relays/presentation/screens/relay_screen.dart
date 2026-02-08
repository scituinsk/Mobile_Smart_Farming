import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/relays/presentation/controllers/relay_ui_controller.dart';
import 'package:pak_tani/src/features/relays/presentation/widgets/relay_modals.dart';
import 'package:pak_tani/src/features/relays/presentation/widgets/relay_group_list.dart';
import 'package:pak_tani/src/features/relays/presentation/widgets/show_menu_edit_sheet.dart';

class RelayScreen extends StatelessWidget {
  RelayScreen({super.key});

  final controller = Get.find<RelayUiController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: MyBackButton(),
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 30.w),
        actions: [
          Obx(() {
            bool isEditing =
                controller.isEditingGroup.value ||
                controller.isEditingRelay.value;
            return MyIcon(
              icon: Icons.edit_outlined,
              onPressed: () {
                ShowMenuEditSheet.show(context);
              },
              iconColor: isEditing ? Colors.white : AppTheme.primaryColor,
              backgroundColor: isEditing ? AppTheme.primaryColor : Colors.white,
            );
          }),
        ],
        title: Column(
          children: [
            Text("relay_title".tr, style: AppTheme.h3),
            Text(
              "relay_subtitle".tr,
              style: AppTheme.textSmall.copyWith(
                color: AppTheme.titleSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: RelayGroupList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RelayModals.showAddModal(context);
        },
        backgroundColor: AppTheme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
