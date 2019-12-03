class DeviceInfo {
  String deviceId;
  String firebaseToken;
  String os;
  String deviceVer;
  String deviceName;
  double lat = 21.0244;
  double lng = 105.843315;

  DeviceInfo(
      {this.deviceId,
      this.firebaseToken,
      this.os,
      this.deviceVer,
      this.deviceName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_id'] = this.deviceId;
    data['notification_token'] = this.firebaseToken;
    data['os'] = this.os;
    data['device_version'] = this.deviceVer;
    data['device_name'] = this.deviceName;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['app_type'] = 0;
    data['country'] = 'VietNam';
    return data;
  }
}
