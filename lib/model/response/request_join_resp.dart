import 'package:myfootball/model/match_user.dart';
import 'package:myfootball/model/response/base_response.dart';

class RequestJoinResponse extends BaseResponse {
  List<MatchUser> matchUsers;

  RequestJoinResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      matchUsers = new List<MatchUser>();
      json['object'].forEach((v) {
        matchUsers.add(new MatchUser.fromJson(v));
      });
    }
  }

  RequestJoinResponse.error(String message) : super.error(message);
}