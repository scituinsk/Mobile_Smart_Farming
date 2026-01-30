import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:pak_tani/src/features/profile/presentation/widgets/contact_info_item_widget.dart';

class ContactInfoWidget extends StatelessWidget {
  const ContactInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      margin: EdgeInsets.only(bottom: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 15.h,
              children: [
                CircleAvatar(
                  radius: 55.r,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Image.asset("assets/image/logo_sc.png"),
                  ),
                ),
                Text("SCIT UIN Sunan Kalijaga", style: AppTheme.h2),
              ],
            ),
            Obx(
              () => Column(
                spacing: 10.h,
                children: [
                  if (controller.contacts["instagram"] != null)
                    ContactInfoItemWidget(
                      text: controller.contacts["instagram"],
                      customIcon: MyCustomIcon.instagram,
                      url:
                          "https://instagram.com/${controller.contacts["instagram"]}",
                    ),
                  if (controller.contacts["whatsapp"] != null)
                    ContactInfoItemWidget(
                      text: controller.contacts["whatsapp"],
                      customIcon: MyCustomIcon.whatsapp,
                      url: 'https://wa.me/${controller.contacts["whatsapp"]}',
                    ),
                  if (controller.contacts["email"] != null)
                    ContactInfoItemWidget(
                      text: controller.contacts["email"],
                      customIcon: MyCustomIcon.gmail,
                      url: "mailto:${controller.contacts["email"]}",
                    ),
                  if (controller.contacts["website"] != null)
                    ContactInfoItemWidget(
                      text: controller.contacts["website"],
                      imageAsset: "assets/image/logo_sc.png",
                      url: "https://${controller.contacts["website"]}",
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
