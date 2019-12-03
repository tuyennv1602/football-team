import 'package:myfootball/model/comment.dart';

class Review {
  double rating;
  Comment comment;

  Review({this.rating, this.comment});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    comment =
        json['review'] != null ? new Comment.fromJson(json['review']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    if (this.comment != null) {
      data['review'] = this.comment.toJson();
    }
    return data;
  }
}
