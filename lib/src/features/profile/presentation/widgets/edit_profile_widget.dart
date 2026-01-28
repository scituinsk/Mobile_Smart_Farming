import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/profile/presentation/controllers/profile_controller.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Form(
        key: controller.formKey,
        child: Column(
          spacing: 30.h,
          children: [
            MyTextField(
              title: "Nama depan",
              hint: "Masukkan nama depan",
              fillColor: Colors.white,
              borderRadius: 10.r,
              controller: controller.firstNameController,
              validator: controller.validateFirstName,
            ),
            MyTextField(
              title: "Nama belakang",
              hint: "Masukkan nama belakang",
              fillColor: Colors.white,
              borderRadius: 10.r,
              controller: controller.lastNameController,
              validator: controller.validateLastName,
            ),
            // MyTextField(
            //   title: "Username",
            //   hint: "Masukkan Username",
            //   fillColor: Colors.white,
            //   borderRadius: 10.r,
            //   controller: controller.usernameController,
            //   validator: controller.validateUsername,
            // ),
            // MyTextField(
            //   title: "Alamat Email",
            //   hint: "Masukkan Alamat Email",
            //   fillColor: Colors.white,
            //   borderRadius: 10.r,
            //   controller: controller.emailController,
            //   validator: controller.validateEmail,
            // ),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: Obx(() {
                final isButtonDisabled =
                    controller.isLoadingSubmit.value ||
                    !controller.isFormValid.value ||
                    !controller.hasChanges.value;
                return MyFilledButton(
                  onPressed: isButtonDisabled
                      ? null
                      : controller.handleEditProfile,
                  backgroundColor: isButtonDisabled
                      ? AppTheme.surfaceActive
                      : AppTheme.primaryColor,
                  child: controller.isLoadingSubmit.value
                      ? SizedBox(
                          width: 30.w,
                          height: 30.h,
                          child: CircularProgressIndicator(),
                        )
                      : Text("Simpan Perubahan"),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
