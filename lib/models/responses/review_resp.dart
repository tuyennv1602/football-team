import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/review.dart';

class ReviewResponse extends BaseResponse {
  Review review;

  ReviewResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      review = Review.fromJson(json['object']);
    }
  }

  ReviewResponse.error(String message) : super.error(message);
}
