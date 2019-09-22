import 'package:flutter/cupertino.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_view_model.dart';

class RequestMemberViewModel extends BaseViewModel {
  Api _api;

  RequestMemberViewModel({@required Api api}) : _api = api;
}
