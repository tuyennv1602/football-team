import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/model/transaction.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class FinanceViewModel extends BaseViewModel {
  Api _api;

  List<Transaction> transactions = [];

  int teamId;

  DateTime currentDate = DateTime.now();

  FinanceViewModel({@required Api api, @required this.teamId}) : _api = api;

  changeMonth(DateTime dateTime) {
    this.currentDate = dateTime;
    notifyListeners();
    getTransactions();
  }

  String get getCurrentMonth => DateFormat('MM/yyyy').format(currentDate);

  Future<void> createFundNotify( String title, String price, DateTime expiredDate) async {
    UIHelper.showProgressDialog;
    var resp = await _api.createFundNotify(
        teamId,
        title,
        StringUtil.getPriceFromString(price),
        DateUtil.getDateTimeStamp(expiredDate));
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Thông báo đã được tạo', isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> getTransactions() async {
    setBusy(true);
    var resp = await _api.getTransactionByTeam(teamId, getCurrentMonth);
    if (resp.isSuccess) {
      this.transactions = resp.transactions;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    setBusy(false);
  }

  Future<void> createExchange( String price, int type, String title) async {
    UIHelper.showProgressDialog;
    var resp = await _api.createExchange(
        teamId, StringUtil.getPriceFromString(price), type, title);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
