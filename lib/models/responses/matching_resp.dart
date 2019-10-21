import 'package:myfootball/models/matching.dart';
import 'package:myfootball/models/responses/base_response.dart';

class MatchingResponse extends BaseResponse {
  List<Matching> matchings;

  MatchingResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      matchings = new List<Matching>();
      json['object'].forEach((v) {
        var matching = new Matching.fromJson(v);
        matchings.add(matching);
      });
    }
  }

  MatchingResponse.error(String message) : super.error(message);
}
