import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/relay_modul/relay_add_modal.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/relay_modul/relay_group.dart';

class RelayScreen extends StatelessWidget {
  const RelayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = Get.height;
    final mediaQueryWidth = Get.width;
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
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          height: mediaQueryHeight,
          width: mediaQueryWidth,
          child: ListView(
            children: [
              RelayGroup(title: "Green house A"),
              SizedBox(height: 20),
              RelayGroup(title: "Green house B"),
            ],
          ),
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
