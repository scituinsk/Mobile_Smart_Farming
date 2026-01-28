import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/profile/presentation/controllers/profile_controller.dart';

class PhotoProfileWidget extends StatelessWidget {
  const PhotoProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Column(
      children: [
        Stack(
          children: [
            Obx(
              () => CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.white,
                child: controller.currentUser.value?.image != null
                    ? ClipOval(
                        child: Image(
                          image: NetworkImage(
                            (AppConfig.baseUrl +
                                controller.currentUser.value!.image!),
                          ),
                          fit: BoxFit.cover,
                          width: 100.w,
                          height: 100.h,
                        ),
                      )
                    : Icon(
                        Icons.person_rounded,
                        size: 70.r,
                        color: AppTheme.surfaceActive,
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: MyIcon(
                icon: Icons.edit_outlined,
                iconColor: Colors.white,
                iconSize: 18,
                padding: 5,
                backgroundColor: AppTheme.primaryColor,
                onPressed: () => controller.handleEditPhotoProfile(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Obx(
          () => Text(
            controller.currentUser.value?.username ?? "undifined",
            style: AppTheme.h4.copyWith(fontSize: 18.sp),
          ),
        ),
        SizedBox(height: 2.h),
        Obx(
          () => Text(
            controller.currentUser.value?.email ?? "undifined",
            style: AppTheme.textAction,
          ),
        ),
      ],
    );
  }
}
