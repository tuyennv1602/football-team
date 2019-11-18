import 'package:myfootball/models/match_history.dart';
import 'package:myfootball/models/responses/base_response.dart';

class MatchHistoryResponse extends BaseResponse {
  List<MatchHistory> matchHistories;

  MatchHistoryResponse.success(int teamId, Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      matchHistories = new List<MatchHistory>();
      json['object'].forEach((v) {
        matchHistories.add(new MatchHistory.fromJson(teamId, v));
      });
    }
  }

  MatchHistoryResponse.error(String message) : super.error(message);
}
