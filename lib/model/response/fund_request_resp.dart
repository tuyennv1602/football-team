import '../fund_member.dart';
import '../fund_request.dart';
import 'base_response.dart';

class FundRequestResponse extends BaseResponse {
  FundRequest request;

  FundRequestResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      request = FundRequest.fromJson(json['object']);
    }
  }

  FundRequestResponse.error(String message) : super.error(message);

  List<FundMember> get members => request.members;
}
