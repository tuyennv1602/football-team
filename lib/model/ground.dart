import 'package:myfootball/model/field.dart';
import 'package:myfootball/utils/string_util.dart';

class Ground {
  int id;
  int status;
  int userId;
  String phone;
  String name;
  String rule;
  String avatar;
  double deposit;
  String address;
  double lat;
  double lng;
  double rating;
  bool rated;
  int createDate;
  int wardId;
  String wardName;
  int districtId;
  String districtName;
  int provinceId;
  String provinceName;
  int countField;
  int countFreeField;
  double distance;
  List<Field> fields;

  Ground(
      {this.id,
      this.status,
      this.userId,
      this.phone,
      this.name,
      this.rule,
      this.avatar,
      this.deposit,
      this.address,
      this.lat,
      this.lng,
      this.rating,
      this.rated,
      this.createDate,
      this.wardId,
      this.wardName,
      this.districtId,
      this.districtName,
      this.provinceId,
      this.provinceName,
      this.countField,
      this.countFreeField,
      this.fields,
      this.distance});

  Ground.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    userId = json['userId'];
    phone = json['phone'];
    name = json['name'];
    rule = json['rule'];
    avatar = json['avatar'];
    deposit = json['deposit'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    rating = json['rating'];
    rated = json['rated'];
    createDate = json['create_date'];
    wardId = json['ward_id'];
    wardName = json['ward_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
    provinceId = json['province_id'];
    provinceName = json['province_name'];
    countField = json['count_field'];
    countFreeField = json['count_free_field'];
    if (json['fields'] != null) {
      fields = new List<Field>();
      json['fields'].forEach((v) {
        fields.add(new Field.fromJson(v));
      });
    }
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['userId'] = this.userId;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['rule'] = this.rule;
    data['avatar'] = this.avatar;
    data['deposit'] = this.deposit;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['rating'] = this.rating;
    data['rated'] = this.rated;
    data['create_date'] = this.createDate;
    data['ward_id'] = this.wardId;
    data['ward_name'] = this.wardName;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    data['province_id'] = this.provinceId;
    data['province_name'] = this.provinceName;
    data['count_field'] = this.countField;
    data['count_free_field'] = this.countFreeField;
    if (this.fields != null) {
      data['fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String get getRegion => '$wardName, $districtName, $provinceName';

  String get getDeposit => StringUtil.formatCurrency(deposit);

  String get getDistance =>
      distance == null ? 'NaN' : '${(distance / 1000).toStringAsFixed(1)} km';

  String get tag => 'ground-$id';
}
