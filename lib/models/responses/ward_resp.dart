import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/ward.dart';

class WardResponse extends BaseResponse {
  List<Ward> wards;

  WardResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      wards = new List<Ward>();
      json['object'].forEach((v) {
        wards.add(new Ward.fromJson(v));
      });
    }
  }

  WardResponse.error(String message) : super.error(message);
}
