import 'package:myfootball/models/comment.dart';
import 'package:myfootball/models/responses/base_response.dart';

class CommentResponse extends BaseResponse {
  List<Comment> comments;

  CommentResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      comments = new List<Comment>();
      json['object'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });
    }
  }

  CommentResponse.error(String message) : super.error(message);
}
