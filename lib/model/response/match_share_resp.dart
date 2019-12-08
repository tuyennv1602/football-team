import 'package:myfootball/model/match_share.dart';
import 'package:myfootball/model/response/base_response.dart';

class MatchShareResponse extends BaseResponse {
  List<MatchShare> matchShares;

  MatchShareResponse.success(Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      matchShares = new List<MatchShare>();
      json['object'].forEach((v) {
        matchShares.add(new MatchShare.fromJson(v));
      });
    }
  }

  MatchShareResponse.error(String message) : super.error(message);
}