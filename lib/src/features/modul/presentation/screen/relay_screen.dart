import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/relay_modul/relay_add_modal.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/relay_modul/relay_group_list.dart';

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
        title: Column(
          children: [
            Text("Grub Relay", style: AppTheme.h3),
            Text(
              "Tekan tahan untuk seret relay",
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
          RelayAddModal.show(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
