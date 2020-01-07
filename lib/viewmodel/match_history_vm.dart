import 'package:flutter/material.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MatchHistoryViewModel extends BaseViewModel {
  Api _api;
  List<MatchHistory> matchHistories = [];
  int page = 1;
  bool canLoadMore = false;

  MatchHistoryViewModel({@required Api api}) : _api = api;

  Future<void> getHistories(int teamId, bool isRefresh) async {
    if (isRefresh) {
      page = 1;
      matchHistories.clear();
    } else {
      setBusy(page == 1);
    }
    var resp = await _api.getMatchHistory(teamId, page);
    if (resp.isSuccess) {
      this.matchHistories.addAll(resp.matchHistories);
      this.canLoadMore = resp.matchHistories.length == 10;
      page++;
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
      matchHistories[index].updatePoint(resp.point);
      notifyListeners();
      UIHelper.showSimpleDialog(
          'Cảm ơn bạn vì đã xác nhận. Các cầu thủ có thể tham gia xác nhận tỉ số để tăng độ tín nhiệm của kết quả và nhận điểm thưởng',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
