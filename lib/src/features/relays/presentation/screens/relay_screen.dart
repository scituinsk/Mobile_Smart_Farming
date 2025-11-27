import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/relays/presentation/widgets/relay_modals.dart';
import 'package:pak_tani/src/features/relays/presentation/widgets/relay_group_list.dart';
import 'package:pak_tani/src/features/relays/presentation/widgets/show_menu_edit_sheet.dart';

class RelayScreen extends StatelessWidget {
  const RelayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: MyBackButton(),
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 30),
        actions: [
          MyIcon(
            icon: Icons.edit_outlined,
            onPressed: () {
              ShowMenuEditSheet.show(context);
            },
            iconColor: Colors.white,
            backgroundColor: AppTheme.primaryColor,
          ),
        ],
        title: Column(
          children: [
            Text("Grub Relay", style: AppTheme.h3),
            Text(
              "Atur group saklar perangkat irigasi",
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
