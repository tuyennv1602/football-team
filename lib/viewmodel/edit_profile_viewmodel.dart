import 'package:flutter/material.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class EditProfileViewModel extends BaseViewModel {
  Api _api;

  EditProfileViewModel({@required Api api}) : _api = api;
}