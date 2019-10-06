import 'package:myfootball/models/province.dart';
import 'package:myfootball/models/responses/base_response.dart';

class ProvinceResponse extends BaseResponse {
  List<Province> provinces;

  ProvinceResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      provinces = new List<Province>();
      json['object'].forEach((v) {
        var province = new Province.fromJson(v);
        provinces.add(province);
      });
    }
  }

  ProvinceResponse.error(String message) : super.error(message);
}
