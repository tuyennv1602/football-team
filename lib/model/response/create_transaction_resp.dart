import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/transaction.dart';

class CreateTransactionResponse extends BaseResponse {
  Transaction transaction;

  CreateTransactionResponse.success(Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      transaction = Transaction.fromJson(json['object']);
    }
  }

  CreateTransactionResponse.error(String message) : super.error(message);
}
