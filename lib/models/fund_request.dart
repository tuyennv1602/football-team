import 'member.dart';

class FundRequest {
  int id;
  double price;
  String title;
  int groupId;
  int expireDate;
  int createDate;
  List<Member> members;

  FundRequest(
      {this.id,
      this.price,
      this.title,
      this.groupId,
      this.expireDate,
      this.createDate,
      this.members});

  FundRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    title = json['title'];
    groupId = json['group_id'];
    expireDate = json['expire_date'];
    createDate = json['create_date'];
    if (json['members'] != null) {
      members = new List<Member>();
      json['members'].forEach((v) {
        members.add(new Member.fromJson(v));
      });
    }
  }
}
