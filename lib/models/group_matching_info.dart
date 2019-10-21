import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/string_util.dart';

class GroupMatchingInfo {
  int groupId;
  List<TimeInfo> timeInfo;
  List<AddressInfo> addressInfo;

  GroupMatchingInfo({this.groupId, this.timeInfo, this.addressInfo});

  GroupMatchingInfo.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    if (json['time_infos'] != null) {
      timeInfo = new List<TimeInfo>();
      json['time_infos'].forEach((v) {
        timeInfo.add(new TimeInfo.fromJson(v));
      });
    }
    if (json['address_infos'] != null) {
      addressInfo = new List<AddressInfo>();
      json['address_infos'].forEach((v) {
        addressInfo.add(new AddressInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timeInfo != null) {
      data['time_infos'] = this.timeInfo.map((v) => v.toJson()).toList();
    }
    if (this.addressInfo != null) {
      data['address_infos'] = this.addressInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }


}

class TimeInfo {
  int id;
  int status;
  double startHour;
  double endHour;
  String dayOfWeek;

  TimeInfo(
      {this.id, this.status, this.startHour, this.endHour, this.dayOfWeek});

  TimeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    startHour = json['start_hour'];
    endHour = json['end_hour'];
    dayOfWeek = json['day_of_weeks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_hour'] = this.startHour;
    data['end_hour'] = this.endHour;
    data['day_of_weeks'] = this.dayOfWeek;
    return data;
  }

  String get getStartHour => DateUtil().getTimeStringFromDouble(startHour);

  String get getEndHour => DateUtil().getTimeStringFromDouble(endHour);

  String get getTimes {
    if (dayOfWeek == null) {
      return '$getStartHour - $getEndHour';
    }
    if (dayOfWeek.length == 13) {
      return '$getStartHour - $getEndHour (Cả tuần)';
    }
    List<String> _dayOfWeeks = dayOfWeek.split(',');
    _dayOfWeeks = _dayOfWeeks.map((day) => DateUtil().getShortDayOfWeek(int.parse(day))).toList();
    return '$getStartHour - $getEndHour (${_dayOfWeeks.join(',')})';
  }
}

class AddressInfo {
  int id;
  int groupId;
  String wardId;
  String wardName;
  String districtId;
  String districtName;
  String provinceId;
  String provinceName;

  AddressInfo(
      {this.id,
      this.groupId,
      this.wardId,
      this.wardName,
      this.districtId,
      this.districtName,
      this.provinceId,
      this.provinceName});

  AddressInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['group_id'];
    wardId = json['ward_id'].toString();
    wardName = json['ward_name'];
    districtId = json['district_id'].toString();
    districtName = json['district_name'];
    provinceId = json['province_id'].toString();
    provinceName = json['province_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ward_id'] = StringUtil.getIdFromString(this.wardId);
    data['ward_name'] = this.wardName;
    data['district_id'] = StringUtil.getIdFromString(this.districtId);
    data['district_name'] = this.districtName;
    data['province_id'] = StringUtil.getIdFromString(this.provinceId);
    data['province_name'] = this.provinceName;
    return data;
  }

  String get getAddress => '$wardName, $districtName, $provinceName';
}
