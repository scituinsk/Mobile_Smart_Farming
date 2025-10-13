import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/add_modul_form/add_modul_code_input.dart';

class AddModulScreen extends StatelessWidget {
  const AddModulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 25),
            child: MyBackButton(),
          ),
        ),
        title: Column(
          children: [
            Text("Tambah Modul", style: AppTheme.h3),
            Text(
              "Kelola modul sensor & perangkat",
              style: AppTheme.textSmall.copyWith(
                color: AppTheme.titleSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 30),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info, color: AppTheme.primaryColor, size: 28),
          ),
        ],
      ),
      body: Container(
        width: mediaQueryWidth,
        height: mediaQueryHeight,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 30,
          children: [
            Column(
              spacing: 20,
              children: [
                AddModulCodeInput(
                  title: "Kode Modul",
                  hintText: "Ex: 018bd6f8-7d8b-7132-842b-3247e",
                ),
                MyTextField(
                  title: "Nama Modul",
                  hint: "Ex: Green House A",
                  fillColor: Colors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    "Batal",
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
                FilledButton(onPressed: () {}, child: Text("Simpan")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
