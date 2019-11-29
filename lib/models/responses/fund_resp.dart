import 'package:myfootball/models/fund.dart';
import 'package:myfootball/models/responses/base_response.dart';

class FundResponse extends BaseResponse {
  List<Fund> funds;

  FundResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      funds = new List<Fund>();
      json['object'].forEach((v) {
        funds.add(new Fund.fromJson(v));
      });
    }
  }

  FundResponse.error(String message) : super.error(message);
}
