import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/responses/base_response.dart';

class MemberResponse extends BaseResponse {
  List<Member> members;

  MemberResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      members = new List<Member>();
      json['object'].forEach((v) {
        members.add(new Member.fromJson(v));
      });
    }
  }

  MemberResponse.error(String message) : super.error(message);
}