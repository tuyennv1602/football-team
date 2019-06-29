import 'package:myfootball/models/group.dart';
import 'package:myfootball/models/responses/base-response.dart';

class CreateGroupResponse extends BaseResponse {
  Group group;

  CreateGroupResponse.success(Map<String, dynamic> json) : super.success(json) {
    group = json['object'] != null ? Group.fromJson(json['object']) : null;
  }

  CreateGroupResponse.error(String message) : super.error(message);
}
