import '../review.dart';
import 'base_response.dart';

class ReviewResponse extends BaseResponse {
  Review review;

  ReviewResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      review = Review.fromJson(json['object']);
    }
  }

  ReviewResponse.error(String message) : super.error(message);
}
