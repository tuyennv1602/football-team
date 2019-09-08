class Token {
  String token;
  String refreshToken;

  Token({this.token, this.refreshToken});

  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['refresh_token'] = this.refreshToken;
    return data;
  }
}
