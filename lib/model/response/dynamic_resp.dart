import 'package:myfootball/model/response/base_response.dart';

class DynamicResponse extends BaseResponse {
  dynamic data;

  DynamicResponse.success(Map<String, dynamic> json) : super.success(json) {
    data = json['object'];
  }

  DynamicResponse.error(String message) : super.error(message);

  String get code => data;

  double get point => data;

}
