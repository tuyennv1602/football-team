class Header {
  int userId;
  String accessToken;

  Header({this.userId, this.accessToken});

  Header.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['accessToken'] = this.accessToken;
    return data;
  }
}
