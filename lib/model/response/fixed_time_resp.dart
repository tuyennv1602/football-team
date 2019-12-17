import 'package:myfootball/model/fixed_time.dart';
import 'package:myfootball/model/response/base_response.dart';

class FixedTimeResponse extends BaseResponse {
  List<FixedTime> requests;

  FixedTimeResponse.success(Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      requests = new List<FixedTime>();
      json['object'].forEach((v) {
        requests.add(new FixedTime.fromJson(v));
      });
    }
  }

  FixedTimeResponse.error(String message) : super.error(message);
}
