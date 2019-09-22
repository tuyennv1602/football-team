class Headers {
  String accessToken;

  Headers({this.accessToken});

  Headers.fromJson(Map<String, dynamic> json) {
    accessToken = json['Authorization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Authorization'] = 'Bearer ${this.accessToken} ';
    return data;
  }
}
