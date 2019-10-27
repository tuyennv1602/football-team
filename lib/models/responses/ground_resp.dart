import '../ground.dart';
import 'base_response.dart';

class GroundResponse extends BaseResponse {
  Ground ground;

  GroundResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      ground = Ground.fromJson(json['object']);
    }
  }

  GroundResponse.error(String message) : super.error(message);
}
