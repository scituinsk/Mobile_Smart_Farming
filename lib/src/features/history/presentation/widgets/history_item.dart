import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:timelines_plus/timelines_plus.dart';

final List<Map<String, dynamic>> historyData = [
  {
    "timeStart": TimeOfDay(hour: 10, minute: 00),
    "timeEnd": TimeOfDay(hour: 10, minute: 10),
    "relays": [
      "solenoid 1",
      "solenoid 2",
      "solenoid 3",
      "solenoid 3",
      "solenoid 3",
    ],
  },
  {
    "timeStart": TimeOfDay(hour: 10, minute: 11),
    "timeEnd": TimeOfDay(hour: 10, minute: 21),
    "relays": ["solenoid 3", "solenoid 4"],
  },
];

class HistoryItem extends StatefulWidget {
  final String title;
  final String time;
  final String description;
  final bool isExpandable;
  final String date;
  final String? modul;
  final IconData? icon;
  final MyCustomIcon? customIcon;
  const HistoryItem({
    super.key,
    required this.title,
    required this.time,
    required this.description,
    this.isExpandable = true,
    required this.date,
    this.modul,
    this.icon = LucideIcons.calendarSync,
    this.customIcon,
  });

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  void _toggle() {
    if (!widget.isExpandable) return;
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.isExpandable ? _toggle : null,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.r),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: MyIcon(
                      icon: widget.icon ?? LucideIcons.calendarSync,
                      customIcon: widget.customIcon,
                      backgroundColor: Colors.white,
                      iconColor: AppTheme.primaryColor,
                      padding: 10,
                      iconSize: 26,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.r,
                      children: [
                        Text(widget.title, style: AppTheme.h4),
                        if (widget.modul != null)
                          MyDisplayChip(
                            backgroundColor: Colors.white,
                            borderWidth: 1,
                            borderColor: AppTheme.surfaceActive,
                            child: Text(
                              widget.modul!,
                              style: AppTheme.textAction,
                            ),
                          ),
                        Text(widget.description, style: AppTheme.textAction),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: widget.isExpandable
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (widget.isExpandable)
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: MyIcon(
                            icon: Icons.keyboard_arrow_down_rounded,
                            backgroundColor: Colors.white,
                            iconSize: 24,
                            padding: 2,
                          ),
                        ),
                      Column(
                        children: [
                          Text(
                            widget.time,
                            style: AppTheme.textSmall.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Text(
                            widget.date,
                            style: AppTheme.textSmall.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 220),
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: _expanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.r,
                  children: [
                    Text("Detail Grub", style: AppTheme.textAction),
                    FixedTimeline.tileBuilder(
                      theme: TimelineThemeData(
                        direction: Axis.vertical,
                        nodePosition: 0,
                        indicatorPosition: 0,
                        connectorTheme: ConnectorThemeData(
                          thickness: 1.5.r,
                          indent: 3.r,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      builder: TimelineTileBuilder.connected(
                        itemCount: historyData.length + 1,
                        connectionDirection: ConnectionDirection.before,

                        // Garis penghubung
                        connectorBuilder: (context, index, type) {
                          return const SolidLineConnector(color: Colors.grey);
                        },

                        // Indikator Lingkaran (Node)
                        indicatorBuilder: (context, index) {
                          return OutlinedDotIndicator(
                            size: 20.r,
                            borderWidth: 5.w,
                            color: AppTheme.primaryColor,
                            backgroundColor: Colors.white,
                          );
                        },
                        contentsBuilder: (context, index) {
                          final bool isLast = index == historyData.length;
                          if (isLast) {
                            return Padding(
                              padding: EdgeInsets.only(left: 15.0.w),
                              child: Text(
                                'Selesai',
                                style: AppTheme.h4.copyWith(
                                  color: AppTheme.surfaceDarker,
                                ),
                              ),
                            );
                          }
                          final item = historyData[index];
                          final startTime = (item["timeStart"] as TimeOfDay)
                              .format(context);
                          final endTime = (item["timeEnd"] as TimeOfDay).format(
                            context,
                          );

                          return Padding(
                            padding: EdgeInsets.only(
                              left: 15.0.w,
                              bottom: 10.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "$startTime - $endTime",
                                  style: AppTheme.h4.copyWith(
                                    color: AppTheme.surfaceDarker,
                                  ),
                                ),

                                SizedBox(height: 4.r),
                                for (var solenoid in (item['relays'] as List))
                                  Text(
                                    solenoid,
                                    style: AppTheme.h5.copyWith(
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ),

        Container(
          margin: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.titleSecondary.withValues(alpha: 0.3),
                width: 1.2.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
