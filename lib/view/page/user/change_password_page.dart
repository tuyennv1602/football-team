import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/validator.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/button_widget.dart';
import 'package:myfootball/view/widget/light_input_text.dart';
import 'package:myfootball/viewmodel/forgotpassword_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../ui_helper.dart';

// ignore: must_be_immutable
class ChangePasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final email;
  String _password;
  String _code;

  ChangePasswordPage({Key key, this.email}) : super(key: key);

  validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _handleChangePassword(ForgotPasswordViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.changePassword(email, _password, _code);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog(
        'Mật khẩu đã được thay đổi',
        isSuccess: true,
        onConfirmed: () => Navigation.instance.goBack(),
      );
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Đổi mật khẩu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: UIHelper.padding, vertical: UIHelper.size20),
                  child: Column(
              children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: UIHelper.size10),
                              child: LightInputTextWidget(
                                labelText: 'Mật khẩu mới',
                                obscureText: true,
                                validator: Validator.validPassword,
                                onSaved: (value) => _password = value.trim(),
                              ),
                            ),
                            LightInputTextWidget(
                              labelText: 'Mã xác thực',
                              validator: Validator.validCode,
                              onSaved: (value) => _code = value.trim(),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: UIHelper.size10),
                          child: Text(
                            'Mã xác thực đã được gửi tới email mà bạn đã đăng ký. Vui lòng kiểm tra email và sử dụng mã xác thực để lấy đổi mật khẩu',
                            style: textStyleItalic(color: Colors.black87),
                          ),
                        ),
                        BaseWidget<ForgotPasswordViewModel>(
                          model:
                              ForgotPasswordViewModel(api: Provider.of(context)),
                          builder: (c, model, child) => ButtonWidget(
                            child: Text(
                              'ĐỔI MẬT KHẨU',
                              style: textStyleButton(),
                            ),
                            margin: EdgeInsets.only(
                                top: UIHelper.size40,
                                bottom: UIHelper.paddingBottom + UIHelper.size20),
                            onTap: () {
                              if (validateAndSave()) {
                                _handleChangePassword(model);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
                )),
          )
        ],
      ),
    );
  }
}
