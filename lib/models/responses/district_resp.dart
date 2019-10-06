import 'package:myfootball/models/district.dart';
import 'package:myfootball/models/responses/base_response.dart';

class DistrictResponse extends BaseResponse {
  List<District> districts;

  DistrictResponse.success(Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      districts = new List<District>();
      json['object'].forEach((v) {
        var district = new District.fromJson(v);
        districts.add(district);
      });
    }
  }

  DistrictResponse.error(String message) : super.error(message);
}