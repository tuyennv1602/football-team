import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/match_share.dart';
import 'package:myfootball/model/news.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/match_share_resp.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/rss_services.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class SocialViewModel extends BaseViewModel {
  Api _api;

  List<Team> teams = [];
  List<News> news;
  List<MatchShare> matchShares = [];
  bool isLoadingNews = true;
  bool isLoadingMatch = true;
  bool isMatchByCode = false;

  SocialViewModel({@required Api api}) : _api = api;

  Future<void> getRanking() async {
    var resp = await _api.getRanking();
    if (resp.isSuccess) {
      this.teams = resp.teams;
      notifyListeners();
    }
  }

  Future<bool> getSportNews() async {
    var resp = await RssServices().getSportNews();
    if (resp != null) {
      this.news = new List<News>();
      resp.forEach((item) => this.news.add(News(item)));
    }
    this.isLoadingNews = false;
    notifyListeners();
    return Future.value(resp != null);
  }

  Future<bool> getMatchShares(int page) async {
    this.isMatchByCode = false;
    var resp = await _api.getMatchShares(page);
    if (resp.isSuccess && resp.matchShares != null) {
      this.matchShares = resp.matchShares;
    }
    this.isLoadingMatch = false;
    notifyListeners();
    return Future.value(resp.isSuccess);
  }

  Future<BaseResponse> joinMatchByCode(int shareId, String code) async {
    var resp = await _api.joinMatchByCode(shareId, code);
    return resp;
  }

  Future<MatchShareResponse> getMatchSharesByCode(String code) async {
    var resp = await _api.getMatchSharesByCode(code);
    if (resp.isSuccess) {
      if (resp.matchShares != null) {
        this.isMatchByCode = true;
        this.matchShares = resp.matchShares;
        notifyListeners();
      }
    }
    return resp;
  }
}
