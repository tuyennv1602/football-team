import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class RegisterViewModel extends BaseViewModel {
  Api _api;

  RegisterViewModel({@required Api api}) : _api = api;

  Future<void> registerWithEmail(String name, String email, String password,
      String phoneNumber, List<int> roles) async {
    UIHelper.showProgressDialog;
    var resp = await _api.register(name, email, password, phoneNumber, roles);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog(
          'Đăng ký thành công. Vui lòng kiểm tra email để kích hoạt tài khoản',
          onTap: () => NavigationService.instance().goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
