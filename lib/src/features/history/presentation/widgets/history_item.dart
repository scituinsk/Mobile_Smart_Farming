import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/time_parser_helper.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/history/domain/entities/history.dart';
import 'package:pak_tani/src/features/history/domain/value_objects/history_type.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';
import 'package:timelines_plus/timelines_plus.dart';

/// A statefull class for displaying history per item.
class HistoryItem extends StatefulWidget {
  final History history;
  const HistoryItem({super.key, required this.history});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  bool _expanded = false;
  late bool isExpandable;
  late ModulController modulController;
  late String modulName;

  @override
  void initState() {
    super.initState();
    modulController = Get.find<ModulController>();
    isExpandable =
        widget.history.historyType == HistoryType.schedule &&
        (widget.history.scheduleHistories != null &&
            widget.history.scheduleHistories!.isNotEmpty);
    modulName = modulController.devices
        .firstWhere((modul) => modul.id == widget.history.modulId.toString())
        .name;
  }

  void _toggle() {
    if (!isExpandable) return;
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final schedules = widget.history.scheduleHistories ?? [];

    final LinkedHashMap<String, List<String>> pins = LinkedHashMap();
    final Map<String, Map<String, TimeOfDay>> times = {};

    for (var schedule in schedules) {
      final start = schedule.startTime;
      final end = schedule.endTime;
      final key =
          "${TimeParserHelper.formatTimeOfDay(start)}-${TimeParserHelper.formatTimeOfDay(end)}";

      pins.putIfAbsent(key, () => []).add(schedule.pinName);
      times.putIfAbsent(key, () => {"start": start, "end": end});
    }
    final createdAt =
        "${widget.history.createdAt.day}/${widget.history.createdAt.month}/${widget.history.createdAt.year}";

    final List<Map<String, dynamic>> groupedSchedules = pins.entries.map((e) {
      final key = e.key;
      return {
        "start": times[key]!["start"] as TimeOfDay,
        "end": times[key]!["end"] as TimeOfDay,
        "pins": e.value,
      };
    }).toList();

    return Column(
      children: [
        InkWell(
          onTap: isExpandable ? _toggle : null,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.r),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: MyIcon(
                      customIcon:
                          widget.history.historyType?.icon ??
                          MyCustomIcon.greenHouse,
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
                        Text(
                          widget.history.name ?? "history_default_name".tr,
                          style: AppTheme.h4,
                        ),
                        if (widget.history.historyType != HistoryType.modul)
                          MyDisplayChip(
                            backgroundColor: Colors.white,
                            borderWidth: 1,
                            borderColor: AppTheme.surfaceActive,
                            child: Text(modulName, style: AppTheme.textAction),
                          ),
                        Text(
                          widget.history.message ??
                              (widget.history.historyType ==
                                      HistoryType.schedule
                                  ? "history_error_schedule".tr
                                  : "history_error_task".tr),
                          style: AppTheme.textAction.copyWith(
                            color: widget.history.message == null
                                ? AppTheme.errorColor
                                : AppTheme.onDefaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: isExpandable
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (isExpandable)
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
                            widget.history.alarmTime != null
                                ? TimeParserHelper.formatTimeOfDay(
                                    widget.history.alarmTime!,
                                  )
                                : "${widget.history.createdAt.hour}:${widget.history.createdAt.minute}",
                            style: AppTheme.textSmall.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Text(
                            createdAt,
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
          secondChild: _expanded && groupedSchedules.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: 66.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10.r,
                    children: [
                      Text(
                        "history_group_detail".tr,
                        style: AppTheme.textAction,
                      ),
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
                          itemCount: groupedSchedules.length + 1,
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
                            final bool isLast =
                                index == groupedSchedules.length;
                            if (isLast) {
                              return Padding(
                                padding: EdgeInsets.only(left: 15.0.w),
                                child: Text(
                                  'history_finished'.tr,
                                  style: AppTheme.h4.copyWith(
                                    color: AppTheme.surfaceDarker,
                                  ),
                                ),
                              );
                            }
                            final scheduleHistory = groupedSchedules[index];
                            final startTime =
                                (scheduleHistory["start"] as TimeOfDay).format(
                                  context,
                                );
                            final endTime =
                                (scheduleHistory["end"] as TimeOfDay).format(
                                  context,
                                );
                            final pins =
                                scheduleHistory["pins"] as List<String>;

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
                                  for (var solenoid in pins)
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
                  ),
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
