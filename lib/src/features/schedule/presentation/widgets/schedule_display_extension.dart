import 'package:get/get.dart';
import 'package:pak_tani/src/features/schedule/domain/entities/schedule.dart';

extension ScheduleDisplayExtension on Schedule {
  String getActiveDaysLocalized() {
    final codes = getActiveDayCodes();

    if (codes.isEmpty) return 'schedule_no_repeat'.tr;
    if (codes.length == 7) return 'schedule_every_day'.tr;

    final localizedDays = codes.map((code) {
      return 'weekday_${code}_short'.tr;
    }).toList();

    return localizedDays.join(', ');
  }
}
