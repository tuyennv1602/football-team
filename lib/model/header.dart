class Header {
  String accessToken;
  String deviceId;

  Header({this.accessToken, this.deviceId});

  Header.fromJson(Map<String, dynamic> json) {
    accessToken = json['Authorization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessToken != null) {
      data['Authorization'] = 'Bearer ${this.accessToken}';
    }
    data['app-type'] = 0;
    data['device-id'] = deviceId;
    return data;
  }
}
