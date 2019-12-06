import 'package:flutter/material.dart';
import 'package:myfootball/model/transaction.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class UserTransactionViewModel extends BaseViewModel {
  Api _api;

  List<Transaction> transactions = [];

  UserTransactionViewModel({@required Api api}) : _api = api;

  Future<void> getTransactions(int page) async {
    setBusy(true);
    var resp = await _api.getUserTransaction(page);
    if (resp.isSuccess) {
      this.transactions = resp.transactions;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    setBusy(false);
  }
}
