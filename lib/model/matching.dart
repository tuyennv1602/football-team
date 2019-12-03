import 'package:myfootball/model/matching_time_slot.dart';
import 'package:myfootball/utils/object_utils.dart';

class Matching {
  String id;
  double rating;
  double point;
  int rank;
  int groupId;
  String groupName;
  String logo;
  String dress;
  int confrontation1;
  int confrontation2;
  double startHour;
  double endHour;
  int dayOfWeek;
  int wardId;
  String wardName;
  int districtId;
  String districtName;
  int provinceId;
  String provinceName;
  List<MatchingTimeSlot> timeSlots;

  Matching(
      {this.id,
      this.rating,
      this.point,
      this.rank,
      this.groupId,
      this.groupName,
      this.logo,
      this.dress,
      this.confrontation1,
      this.confrontation2,
      this.startHour,
      this.endHour,
      this.dayOfWeek,
      this.wardId,
      this.wardName,
      this.districtId,
      this.districtName,
      this.provinceId,
      this.provinceName,
      this.timeSlots});

  Matching.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    point = json['point'];
    rank = json['rank'];
    groupId = json['group_id'];
    groupName = json['group_name'];
    logo = json['logo'];
    dress = json['dress'];
    confrontation1 = json['confrontation_1'];
    confrontation2 = json['confrontation2'];
    startHour = json['start_hour'];
    endHour = json['end_hour'];
    dayOfWeek = json['day_of_week'];
    wardId = json['ward_id'];
    wardName = json['ward_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
    provinceId = json['province_id'];
    provinceName = json['province_name'];
    if (json['ground_time_slots'] != null) {
      timeSlots = new List<MatchingTimeSlot>();
      json['ground_time_slots'].forEach((v) {
        timeSlots.add(new MatchingTimeSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['point'] = this.point;
    data['rank'] = this.rank;
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    data['logo'] = this.logo;
    data['dress'] = this.dress;
    data['confrontation_1'] = this.confrontation1;
    data['confrontation2'] = this.confrontation2;
    data['start_hour'] = this.startHour;
    data['end_hour'] = this.endHour;
    data['day_of_week'] = this.dayOfWeek;
    data['ward_id'] = this.wardId;
    data['ward_name'] = this.wardName;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    data['province_id'] = this.provinceId;
    data['province_name'] = this.provinceName;
    return data;
  }

  Map<int, List<MatchingTimeSlot>> get getMappedTimeSlot =>
      ObjectUtil.mapMatchingTimeSlotByDayOfWeek(timeSlots);
}
