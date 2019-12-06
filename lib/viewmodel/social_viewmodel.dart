import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/news.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/rss_services.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class SocialViewModel extends BaseViewModel {
  Api _api;

  List<Team> teams = [];
  List<News> news;
  bool isLoadingNews = true;

  SocialViewModel({@required Api api}) : _api = api;

  Future<void> getRanking() async {
    var resp = await _api.getRanking();
    if (resp.isSuccess) {
      this.teams = resp.teams;
      notifyListeners();
    }
  }

  Future<void> getSportNews() async {
    var resp = await RssServices().getSportNews();
    if (resp != null) {
      this.news = new List<News>();
      resp.forEach((item) => this.news.add(News(item)));
    }
    this.isLoadingNews = false;
    notifyListeners();
  }
}
