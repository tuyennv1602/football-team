import 'package:flutter/material.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class EditProfileViewModel extends BaseViewModel {
  Api _api;

  EditProfileViewModel({@required Api api}) : _api = api;
}