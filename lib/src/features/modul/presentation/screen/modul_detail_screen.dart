import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
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
    final controller = Get.put(ModulDetailUiController());

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
              return Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                SizedBox(
                  height: 318,
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

                      Container(
                        height: 318,
                        width: mediaQueryWidth,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            stops: [0.4, 1.0], // Atur posisi transisi gradient
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 15,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyBackButton(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Obx(
                                  () => ExpandableButton(
                                    width: 180,
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
                                ),
                                Obx(() {
                                  final content = controller
                                      .modul
                                      .value
                                      ?.features
                                      ?.firstWhereOrNull(
                                        (element) => element.name == "battery",
                                      );

                                  if (content == null) {
                                    return SizedBox.shrink();
                                  }

                                  final percent =
                                      int.tryParse(content.data.toString()) ??
                                      0;

                                  return BatteryStatus(percent: percent);
                                }),
                              ],
                            ),
                            ModulDetailDropdownMenu(),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 28,
                        left: 15,
                        right: 15,
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
                                      height: 52,
                                      width: controller.isQrVisible.value
                                          ? 350
                                          : 320,
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                        color: Color.lerp(
                                          Colors.transparent,
                                          Colors.white,
                                          value,
                                        ),
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                              left: Radius.circular(20),
                                              right: Radius.circular(20),
                                            ),
                                        border: Border.all(
                                          color: Color.lerp(
                                            Colors.white.withValues(alpha: 0.3),
                                            Colors.transparent,
                                            value,
                                          )!,
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                              left: Radius.circular(20),
                                              right: Radius.circular(20),
                                            ),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 10 * (1 - value),
                                            sigmaY: 10 * (1 - value),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              spacing: 6,
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
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
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
                                                                print(
                                                                  "lihat qr",
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
                  left: 20,
                  right: 20,
                  top: 82,
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
                            blur: 10,
                            // padding: const EdgeInsets.symmetric(
                            //   horizontal: 16,
                            //   vertical: 9,
                            // ),
                            padding: EdgeInsetsGeometry.all(0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 9,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      // Outline hitam
                                      Text(
                                        controller.modul.value!.name,
                                        style: AppTheme.h4.copyWith(
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color = Colors.black,
                                        ),
                                      ),
                                      // Text putih di atas
                                      Text(
                                        controller.modul.value!.name,
                                        style: AppTheme.h4.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      // Outline hitam untuk deskripsi
                                      Text(
                                        controller.modul.value!.descriptions ??
                                            "",
                                        style: AppTheme.text.copyWith(
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 0.8
                                            ..color = Colors.black,
                                        ),
                                      ),
                                      // Text putih di atas
                                      Text(
                                        controller.modul.value!.descriptions ??
                                            "",
                                        style: AppTheme.text.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey('collapsed')),
                  ),
                ),
                Positioned.fill(top: 298, child: ModulDetailFeatureSection()),
              ],
            );
          }),
        ),
      ),
    );
  }
}
