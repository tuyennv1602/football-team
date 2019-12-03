import 'package:myfootball/model/group_matching_info.dart';

import 'base_response.dart';

class CreateMatchingResponse extends BaseResponse {
  List<GroupMatchingInfo> groupMatchingInfos;

  CreateMatchingResponse.success(Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      groupMatchingInfos = new List<GroupMatchingInfo>();
      json['object'].forEach((v) {
        var info = new GroupMatchingInfo.fromJson(v);
        groupMatchingInfos.add(info);
      });
    }
  }

  CreateMatchingResponse.error(String message) : super.error(message);
}
