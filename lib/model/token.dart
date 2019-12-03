class Token {
  String token;
  String refreshToken;
  String deviceId;

  Token({this.token, this.refreshToken, this.deviceId});

  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refresh_token'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['refresh_token'] = this.refreshToken;
    data['device_id'] = this.deviceId;
    return data;
  }
}
