import 'package:flutter/material.dart';
import 'package:myfootball/models/match_history.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class MatchHistoryViewModel extends BaseViewModel {
  Api _api;
  List<MatchHistory> matchHistories;

  MatchHistoryViewModel({@required Api api}) : _api = api;

  Future<void> getHistories(int teamId, int page) async {
    setBusy(true);
    var resp = await _api.getHistories(teamId, page);
    if (resp.isSuccess) {
      this.matchHistories = resp.matchHistories;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    setBusy(false);
  }

  Future<void> updateScore(
      int index, int historyId, String firstScore, String secondScore) async {
    int _firstScore = firstScore != null ? int.parse(firstScore) : 0;
    int _secondScore = secondScore != null ? int.parse(secondScore) : 0;
    UIHelper.showProgressDialog;
    var resp = await _api.updateScore(historyId, _firstScore, _secondScore);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      matchHistories[index].sendGroupScore = _firstScore;
      matchHistories[index].receiveGroupScore = _secondScore;
      notifyListeners();
      UIHelper.showSimpleDialog(
          'Đã gửi yêu cầu xác nhận tỉ số tới đối tác. Vui lòng chờ đối tác xác nhận!',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> confirmScore(int index, int historyId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.confirmMatchResult(historyId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      matchHistories[index].isConfirmed = true;
      notifyListeners();
      UIHelper.showSimpleDialog(
          'Cảm ơn vì đã xác nhận. Các cầu thủ có thể tham gia xác nhận tỉ số để nhận điểm thưởng',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
