import 'package:myfootball/models/match_schedule.dart';
import 'package:myfootball/models/responses/base_response.dart';

class MatchScheduleResponse extends BaseResponse {
  List<MatchSchedule> matchSchedules;

  MatchScheduleResponse.success(int teamId, Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      matchSchedules = new List<MatchSchedule>();
      json['object'].forEach((v) {
        matchSchedules.add(new MatchSchedule.fromJson(teamId, v));
      });
    }
  }

  MatchScheduleResponse.error(String message) : super.error(message);
}
