import 'package:dio/dio.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/group_schedule/data/models/schedule_model.dart';
import 'package:pak_tani/src/features/group_schedule/domain/datasources/schedule_remote_datasource.dart';

class ScheduleRemoteDatasourceImpl extends ScheduleRemoteDatasource {
  final ApiService _apiService;
  ScheduleRemoteDatasourceImpl(this._apiService);

  @override
  Future<List<ScheduleModel>?> getListScheduleInGroup(String groupId) async {
    final Response response = await _apiService.get(
      "/schedule/group/$groupId/alarms/",
    );
    final responseData = response.data["data"] as List<dynamic>;

    return responseData
        .map((json) => ScheduleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ScheduleModel> addScheduleInGroup(
    String groupId, {
    required String time,
    int? duration,
    bool? repeatMonday,
    bool? repeatTuesday,
    bool? repeatWednesday,
    bool? repeatThursday,
    bool? repeatFriday,
    bool? repeatSaturday,
    bool? repeatSunday,
  }) async {
    final FormData formData = FormData.fromMap({
      "group": groupId,
      "time": time,
      "is_active": true,
      if (duration != null) "duration": duration,
      if (repeatMonday != null) "repeat_monday": repeatMonday,
      if (repeatTuesday != null) "repeat_tuesday": repeatTuesday,
      if (repeatWednesday != null) "repeat_wednesday": repeatWednesday,
      if (repeatThursday != null) "repeat_thursday": repeatThursday,
      if (repeatFriday != null) "repeat_friday": repeatFriday,
      if (repeatSaturday != null) "repeat_saturday": repeatSaturday,
      if (repeatSunday != null) "repeat_sunday": repeatSunday,
    });

    final Response response = await _apiService.post(
      "/schedule/alarms/",
      data: formData,
    );

    final responseData = response.data["data"] as Map<String, dynamic>;

    return ScheduleModel.fromJson(responseData);
  }

  @override
  Future<ScheduleModel> editScheduleInGroup(
    String id, {
    String? time,
    int? duration,
    bool? isActive,
    bool? repeatMonday,
    bool? repeatTuesday,
    bool? repeatWednesday,
    bool? repeatThursday,
    bool? repeatFriday,
    bool? repeatSaturday,
    bool? repeatSunday,
  }) async {
    final FormData formData = FormData.fromMap({
      if (time != null) "time": time,
      if (duration != null) "duration": duration,
      if (isActive != null) "is_active": isActive,
      if (repeatMonday != null) "repeat_monday": repeatMonday,
      if (repeatTuesday != null) "repeat_tuesday": repeatTuesday,
      if (repeatWednesday != null) "repeat_wednesday": repeatWednesday,
      if (repeatThursday != null) "repeat_thursday": repeatThursday,
      if (repeatFriday != null) "repeat_friday": repeatFriday,
      if (repeatSaturday != null) "repeat_saturday": repeatSaturday,
      if (repeatSunday != null) "repeat_sunday": repeatSunday,
    });

    final Response response = await _apiService.patch(
      "/schedule/alarms/$id/",
      data: formData,
    );

    final responseData = response.data["data"] as Map<String, dynamic>;

    return ScheduleModel.fromJson(responseData);
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await _apiService.delete("/schedule/alarms/$id/");
  }
}
