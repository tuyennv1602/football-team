class BaseResponse {
  String token;
  String errorMessage;
  String errorCode;
  bool success;

  BaseResponse.success(Map<String, dynamic> json) {
    token = json['token'];
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
    success = json['success'];
  }

  BaseResponse.error(String message) {
    this.success = false;
    this.errorMessage = message;
  }
}
