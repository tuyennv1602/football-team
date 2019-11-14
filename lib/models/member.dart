import 'package:myfootball/models/user.dart';

class Member extends User {
  double rating;
  bool rated;
  String position;
  bool isCaptain;
  bool isManager;

  Member.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['rating'] != null) {
      rating = double.parse(json['rating'].toString());
    }
    rated = json['rated'];
    position = json['position'];
    isCaptain = json['is_captain'];
    isManager = json['is_manager'];
  }

  List<String> get getPositions => position != null ? position.split(',') : [];

  double get getRating => rating != null ? rating : 0;
}
