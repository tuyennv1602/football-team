import 'package:myfootball/model/response/base_response.dart';

class CreateCodeResponse extends BaseResponse {
  String code;

  CreateCodeResponse.success(Map<String, dynamic> json) : super.success(json) {
    code = json['object'];
  }

  CreateCodeResponse.error(String message) : super.error(message);
}
