import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_shadows.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/modul_feature_helper.dart';
import 'package:pak_tani/src/core/widgets/battery_status.dart';
import 'package:pak_tani/src/core/widgets/expandable_button.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_detail_ui_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_detail_dropdown_menu.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_detail_feature_section.dart';

class ModulDetailScreen extends StatelessWidget {
  const ModulDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ModulDetailUiController>();

    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Memuat perangkat..."),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                SizedBox(
                  height: mediaQueryHeight * 35 / 100,
                  child: Stack(
                    children: [
                      Obx(() {
                        final modul = controller.modul.value;
                        late ImageProvider imageProvider;
                        if (modul != null) {
                          imageProvider = modul.image != null
                              ? NetworkImage((AppConfig.baseUrl + modul.image!))
                              : const AssetImage(
                                  'assets/image/default_modul.jpg',
                                );
                        } else {
                          imageProvider = const AssetImage(
                            'assets/image/default_modul.jpg',
                          );
                        }

                        return Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        );
                      }),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 18.h,
                          horizontal: 15.w,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyBackButton(),
                            Obx(() {
                              final batteryData = controller
                                  .modul
                                  .value
                                  ?.features
                                  ?.firstWhereOrNull(
                                    (element) => element.name == "battery",
                                  );

                              final int? batteryStatus =
                                  ModulFeatureHelper.getBatteryValue(
                                    batteryData,
                                  );

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5.r,
                                children: [
                                  ExpandableButton(
                                    width: 180.w,
                                    onExpandChanged: (isExpanded) =>
                                        controller.isTitleExpanded.value =
                                            isExpanded,
                                    child: Text(
                                      controller.modul.value!.name,
                                      style: AppTheme.h4.copyWith(
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                  if (batteryData != null)
                                    BatteryStatus(percent: batteryStatus!),
                                ],
                              );
                            }),
                            ModulDetailDropdownMenu(),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 28.h,
                        left: 15.w,
                        right: 15.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Obx(
                              () => TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeInOut,
                                tween: Tween<double>(
                                  begin: 0.0,
                                  end: controller.isQrVisible.value ? 1.0 : 0.0,
                                ),
                                builder: (context, value, child) {
                                  return InkWell(
                                    onTap: () => controller.isQrVisible.value =
                                        !controller.isQrVisible.value,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 100),
                                      height: 52.h,
                                      width: controller.isQrVisible.value
                                          ? 365.w
                                          : 320.w,
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                        color: Color.lerp(
                                          Colors.transparent,
                                          Colors.white,
                                          value,
                                        ),
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(20.r),
                                          right: Radius.circular(20.r),
                                        ),
                                        border: Border.all(
                                          color: Color.lerp(
                                            Colors.white.withValues(alpha: 0.3),
                                            Colors.transparent,
                                            value,
                                          )!,
                                          width: 1.w,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(20.r),
                                          right: Radius.circular(20.r),
                                        ),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 10 * (1 - value),
                                            sigmaY: 10 * (1 - value),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(8.r),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    controller
                                                        .modul
                                                        .value!
                                                        .serialId,
                                                    style: TextStyle(
                                                      color: Color.lerp(
                                                        Colors.white,
                                                        AppTheme.primaryColor,
                                                        value,
                                                      ),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      shadows:
                                                          controller
                                                              .isQrVisible
                                                              .value
                                                          ? null
                                                          : AppShadows
                                                                .blackFade,
                                                    ),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),

                                                if (value > 0.7)
                                                  Transform.scale(
                                                    scale: value,
                                                    child:
                                                        controller
                                                            .isQrVisible
                                                            .value
                                                        ? MyIcon(
                                                            icon: LucideIcons
                                                                .qrCode,
                                                            padding: 8,
                                                            iconSize: 20,
                                                            iconColor: AppTheme
                                                                .primaryColor,
                                                            backgroundColor:
                                                                AppTheme
                                                                    .surfaceColor,
                                                            onPressed: () =>
                                                                Get.toNamed(
                                                                  RouteNames
                                                                      .qrCodePage,
                                                                  arguments:
                                                                      controller
                                                                          .modul
                                                                          .value,
                                                                ),
                                                          )
                                                        : null,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 20.w,
                  right: 20.w,
                  top: 82.h,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, -0.25),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: controller.isTitleExpanded.value
                        ? BlurryContainer(
                            key: const ValueKey('expandedDescription'),
                            blur: 6,
                            padding: EdgeInsetsGeometry.all(0),
                            borderRadius: BorderRadius.circular(20.r),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 9.h,
                              ),
                              child: Text(
                                controller.modul.value!.descriptions ?? "",
                                style: AppTheme.text.copyWith(
                                  color: Colors.white,
                                  shadows: AppShadows.blackFade,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey('collapsed')),
                  ),
                ),
                Positioned.fill(
                  top: mediaQueryHeight * 32.5 / 100,
                  child: ModulDetailFeatureSection(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
