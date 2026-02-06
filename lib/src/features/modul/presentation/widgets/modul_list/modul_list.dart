import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_list/modul_item.dart';

class ModulList extends StatelessWidget {
  const ModulList({super.key});

  @override
  Widget build(BuildContext context) {
    final ModulController controller = Get.find<ModulController>();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 17.r,
        children: [
          // ✅ Header with device count (reactive)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Daftar Perangkat", style: AppTheme.h3)],
          ),

          // ✅ Reactive list
          Expanded(
            child: Obx(() {
              if (controller.isLoadingModul.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.h),
                      Text('Memuat Perangkat...'),
                    ],
                  ),
                );
              }

              // ✅ Show empty state
              if (controller.devices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIcon(type: MyCustomIcon.modulEmpty, size: 300),
                      Text(
                        'Tidak ada perangkat yang ditemukan',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.ternaryColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FilledButton.icon(
                        onPressed: () => controller.refreshModulList(),
                        label: Text('Refresh'),
                        icon: Icon(LucideIcons.refreshCcw),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
                  ),
                );
              }

              // ✅ Show device list
              return RefreshIndicator(
                onRefresh: () => controller.refreshModulList(),
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 100.h),
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];

                    return Column(
                      children: [
                        ModulItem(modul: device),
                        SizedBox(height: 20.h),
                      ],
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
