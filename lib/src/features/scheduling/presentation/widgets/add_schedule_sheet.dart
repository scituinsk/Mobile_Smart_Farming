import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/scheduling/presentation/widgets/build_day_chip.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddScheduleSheet {
  static void show(BuildContext context) {
    WoltModalSheet.show(
      context: context,
      useSafeArea: true,
      pageListBuilder: (context) => [
        WoltModalSheetPage(
          backgroundColor: Colors.white,
          hasTopBarLayer: false,
          pageTitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    LucideIcons.x,
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                ),
                Text("Tambah Penjadwalan", style: AppTheme.h4),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    LucideIcons.check,
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              spacing: 33,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Waktu Penjadwalan", style: AppTheme.textDefault),
                    Text("16.30", style: AppTheme.largeTimeText),
                    FilledButton(onPressed: () {}, child: Text("Pilih Waktu")),
                  ],
                ),

                // Durasi Penyiraman Section
                Column(
                  spacing: 21,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            BuildDayChip(day: "Senin", isSelected: false),
                            BuildDayChip(day: "Selasa", isSelected: false),
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

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
