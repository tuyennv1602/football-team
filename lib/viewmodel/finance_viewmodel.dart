import 'package:flutter/material.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class FinanceViewModel extends BaseViewModel {
  Api _api;

  FinanceViewModel({@required Api api}) : _api = api;

  Future<void> createFundNotify(
      int teamId, String title, String price, DateTime expiredDate) async {
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
}
