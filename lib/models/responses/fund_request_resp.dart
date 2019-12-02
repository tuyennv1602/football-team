import 'package:myfootball/models/fund_request.dart';
import 'package:myfootball/models/responses/base_response.dart';

import '../member.dart';

class FundRequestResponse extends BaseResponse {
  FundRequest request;

  FundRequestResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      request = FundRequest.fromJson(json['object']);
    }
  }

  FundRequestResponse.error(String message) : super.error(message);

  List<Member> get members => request.members;
}
