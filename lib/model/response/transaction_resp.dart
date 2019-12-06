import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/transaction.dart';

class TransactionResponse extends BaseResponse {
  List<Transaction> transactions;

  TransactionResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      transactions = new List<Transaction>();
      json['object'].forEach((v) {
        transactions.add(new Transaction.fromJson(v));
      });
    }
  }

  TransactionResponse.error(String message) : super.error(message);
}
