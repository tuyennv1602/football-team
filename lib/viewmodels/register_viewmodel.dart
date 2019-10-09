import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class RegisterViewModel extends BaseViewModel {
  Api _api;

  RegisterViewModel({@required Api api}) : _api = api;

  Future<BaseResponse> registerWithEmail(String name, String email,
      String password, String phoneNumber, List<int> roles) async {
    setBusy(true);
    var resp = await _api.register(name, email, password, phoneNumber, roles);
    setBusy(false);
    return resp;
  }
}
