import 'package:myfootball/models/user.dart';

class Member extends User {
  double rating;
  bool rated;
  String position;

  Member.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['rating'] != null) {
      rating = double.parse(json['rating'].toString());
    }
    rated = json['rated'];
//    position = json['position'];
    position = 'MF,GK,FW,DF';
  }

  List<String> get getPositions => position != null ? position.split(',') : [];

  double get getRating => rating != null ? rating : 0;
}
