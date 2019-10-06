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
    data['group_id'] = this.groupId;
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
  int groupId;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  int createDate;

  TimeInfo(
      {this.id,
      this.status,
      this.groupId,
      this.startHour,
      this.startMinute,
      this.endHour,
      this.endMinute,
      this.createDate});

  TimeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    groupId = json['group_id'];
    startHour = json['start_hour'];
    startMinute = json['start_minute'];
    endHour = json['end_hour'];
    endMinute = json['end_minute'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_hour'] = this.startHour;
    data['start_minute'] = this.startMinute;
    data['end_hour'] = this.endHour;
    data['end_minute'] = this.endMinute;
    return data;
  }

  String get getStartHour => startHour < 10 ? '0$startHour' : '$startHour';

  String get getStartMinute =>
      startMinute < 10 ? '0$startMinute' : '$startMinute';

  String get getEndHour => endHour < 10 ? '0$endHour' : '$endHour';

  String get getEndMinute => endMinute < 10 ? '0$endMinute' : '$endMinute';

  String get getTimes =>
      '$getStartHour:$getStartMinute - $getEndHour:$getEndMinute';
}

class AddressInfo {
  int id;
  int status;
  int groupId;
  int wardId;
  String wardName;
  int districtId;
  String districtName;
  int provinceId;
  String provinceName;

  AddressInfo(
      {this.id,
      this.status,
      this.groupId,
      this.wardId,
      this.wardName,
      this.districtId,
      this.districtName,
      this.provinceId,
      this.provinceName});

  AddressInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    groupId = json['group_id'];
    wardId = json['ward_id'];
    wardName = json['ward_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
    provinceId = json['province_id'];
    provinceName = json['province_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ward_id'] = this.wardId;
    data['ward_name'] = this.wardName;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    data['province_id'] = this.provinceId;
    data['province_name'] = this.provinceName;
    return data;
  }

  String get getAddress => '$wardName, $districtName, $provinceName';
}
