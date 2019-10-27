import 'package:myfootball/models/ground.dart';
import 'package:myfootball/models/responses/base_response.dart';

class ListGroundResponse extends BaseResponse {
  List<Ground> grounds;

  ListGroundResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      grounds = new List<Ground>();
      json['object'].forEach((v) {
        grounds.add(new Ground.fromJson(v));
      });
    }
  }

  ListGroundResponse.error(String message) : super.error(message);
}
