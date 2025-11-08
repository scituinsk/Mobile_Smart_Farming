import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
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
        spacing: 17,
        children: [
          // ✅ Header with device count (reactive)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Daftar Modul", style: AppTheme.h3)],
          ),

          // ✅ Reactive list
          Expanded(
            child: Obx(() {
              // ✅ Show loading state
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading devices...'),
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
                      Icon(
                        Icons.device_hub_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 24),
                      Text(
                        'No devices found',
                        style: AppTheme.h4.copyWith(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.refreshModulList(),
                        child: Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }

              // ✅ Show device list
              return RefreshIndicator(
                onRefresh: () => controller.refreshModulList(),
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 100),
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];
                    print('🔄 Building device $index: ${device.name}');

                    return Column(
                      children: [
                        ModulItem(modul: device),
                        SizedBox(height: 20),
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
