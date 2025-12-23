import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/core/widgets/my_snackbar.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/add_modul_ui_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/add_modul_form/add_modul_code_input.dart';

class AddModulScreen extends StatelessWidget {
  const AddModulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;
    final controller = Get.find<AddModulUiController>();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70.w,
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 25.w),
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
        actionsPadding: EdgeInsets.only(right: 30.w),
        actions: [
          IconButton(
            onPressed: () {
              MySnackbar.error(
                title: "Coming soon...",
                message: "Fitur belum ada, sabar bang :)",
              );
            },
            icon: Icon(Icons.info, color: AppTheme.primaryColor, size: 28),
          ),
        ],
      ),
      body: Container(
        width: mediaQueryWidth,
        height: mediaQueryHeight,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 30.r,
            children: [
              Column(
                spacing: 20.r,
                children: [
                  AddModulCodeInput(
                    title: "Kode Modul",
                    hintText: "Ex: 018bd6f8-7d8b-7132-842b-3247e",
                  ),
                  MyTextField(
                    title: "Password Modul",
                    hint: "Ex: paktani1",
                    fillColor: Colors.white,
                    controller: controller.modulPasswordController,
                    validator: controller.validatePassword,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 8.r,
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
                  Obx(
                    () => FilledButton(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () => controller.handleAddModul(),
                      child: controller.isSubmitting.value
                          ? Padding(
                              padding: EdgeInsets.all(5.0.r),
                              child: CircularProgressIndicator(),
                            )
                          : Text('Tambah Modul'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
