import 'package:flutter/material.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MatchHistoryViewModel extends BaseViewModel {
  Api _api;
  List<MatchHistory> matchHistories;

  MatchHistoryViewModel({@required Api api}) : _api = api;

  Future<void> getHistories(int teamId, int page, bool isRefresh) async {
    setBusy(!isRefresh);
    var resp = await _api.getMatchHistory(teamId, page);
    if (resp.isSuccess) {
      this.matchHistories = resp.matchHistories;
    }
    setBusy(false);
  }

  Future<BaseResponse> updateScore(
      int index, String firstScore, String secondScore) async {
    int _firstScore = firstScore != null ? int.parse(firstScore) : 0;
    int _secondScore = secondScore != null ? int.parse(secondScore) : 0;
    var resp = await _api.updateScore(
        matchHistories[index].id, _firstScore, _secondScore);
    if (resp.isSuccess) {
      matchHistories[index].sendGroupScore = _firstScore;
      matchHistories[index].receiveGroupScore = _secondScore;
      notifyListeners();
    }
    return resp;
  }

  Future<BaseResponse> confirmScore(int index) async {
    var resp = await _api.confirmMatchResult(matchHistories[index].id);
    if (resp.isSuccess) {
      matchHistories[index].isConfirmed = true;
      matchHistories[index].updatePoint(resp.point);
      notifyListeners();
    }
    return resp;
  }
}
