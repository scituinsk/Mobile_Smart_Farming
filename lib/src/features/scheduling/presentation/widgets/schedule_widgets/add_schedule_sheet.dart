import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/scheduling/presentation/widgets/schedule_widgets/build_day_chip.dart';

class AddScheduleSheet {
  static void show(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar di atas
              Container(
                width: 100,
                height: 8,
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Custom top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      LucideIcons.x,
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  ),
                  Text("Tambah Penjadwalan", style: AppTheme.h4),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      LucideIcons.check,
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 33,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Waktu Penjadwalan",
                            style: AppTheme.textDefault,
                          ),
                          Text("16.30", style: AppTheme.largeTimeText),
                          FilledButton(
                            onPressed: () {},
                            child: Text("Pilih Waktu"),
                          ),
                        ],
                      ),

                      // Durasi Penyiraman Section
                      Column(
                        spacing: 21,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Durasi penyiraman",
                                style: AppTheme.textDefault.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    LucideIcons.clock,
                                    color: AppTheme.secondaryColor,
                                  ),
                                  hintText: "Masukkan durasi",
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: TextStyle(
                                    color: AppTheme.onDefaultColor,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),

                          // Ulangi Penyiraman Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ulangi penyiraman",
                                style: AppTheme.textDefault.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16),

                              // Hari dalam seminggu
                              Wrap(
                                spacing: 15,
                                runSpacing: 15,
                                children: [
                                  BuildDayChip(day: "Senin", isSelected: false),
                                  BuildDayChip(
                                    day: "Selasa",
                                    isSelected: false,
                                  ),
                                  BuildDayChip(day: "Rabu", isSelected: false),
                                  BuildDayChip(day: "Kamis", isSelected: false),
                                  BuildDayChip(
                                    day: "Jumat",
                                    isSelected: true,
                                  ), // Selected
                                  BuildDayChip(day: "Sabtu", isSelected: false),
                                  BuildDayChip(day: "Minggu", isSelected: true),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
