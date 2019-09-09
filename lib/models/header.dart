class Header {
  String accessToken;

  Header({this.accessToken});

  Header.fromJson(Map<String, dynamic> json) {
    accessToken = json['Authorization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Authorization'] = 'Bearer ${this.accessToken}';
    return data;
  }
}
