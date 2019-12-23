import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/create_transaction_resp.dart';
import 'package:myfootball/model/transaction.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class FinanceViewModel extends BaseViewModel {
  Api _api;

  List<Transaction> transactions = [];

  int teamId;

  DateTime currentDate = DateTime.now();

  String income = '0đ';
  String outcome = '0đ';

  FinanceViewModel({@required Api api, @required this.teamId}) : _api = api;

  changeMonth(DateTime dateTime) {
    this.currentDate = dateTime;
    notifyListeners();
    getTransactions(false);
  }

  String get getCurrentMonth => DateFormat('MM/yyyy').format(currentDate);

  Future<BaseResponse> createFundNotify(
      String title, String price, DateTime expiredDate) async {
    var resp = await _api.createFundNotify(
        teamId,
        title,
        StringUtil.getPriceFromString(price),
        DateUtil.getDateTimeStamp(expiredDate));
    return resp;
  }

  Future<void> getTransactions(bool isRefresh) async {
    setBusy(!isRefresh);
    var resp = await _api.getTransactionByTeam(teamId, getCurrentMonth);
    if (resp.isSuccess) {
      this.transactions = resp.transactions;
      var _income = 0.0;
      var _outcome = 0.0;
      this.transactions.forEach((transaction) {
        if (transaction.getType == TRANSACTION_TYPE.IN) {
          _income += transaction.price;
        } else {
          _outcome += transaction.price;
        }
      });
      income = StringUtil.formatCurrency(_income);
      outcome = StringUtil.formatCurrency(_outcome);
    }
    setBusy(false);
  }

  Future<CreateTransactionResponse> createExchange(
      String price, int type, String title) async {
    var resp = await _api.createExchange(
        teamId, StringUtil.getPriceFromString(price), type, title);
    if (resp.isSuccess) {
      this.transactions.insert(0, resp.transaction);
      notifyListeners();
    }
    return resp;
  }
}
