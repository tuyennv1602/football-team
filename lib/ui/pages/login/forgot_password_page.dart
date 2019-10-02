import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/border_textformfield.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/utils/validator.dart';
import 'package:myfootball/viewmodels/forgotpassword_view_model.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _code;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _handleSubmit(ForgotPasswordViewModel model) async {
    UIHelper.showProgressDialog;
    if (!model.isChangePassword) {
      var _resp = await model.forgotPassword(_email);
      UIHelper.hideProgressDialog;
      if (_resp.isSuccess) {
        UIHelper.showSimpleDialog('Mã xác thực đã được gửi');
      } else {
        UIHelper.showSimpleDialog(_resp.errorMessage);
      }
    } else {
      var _resp = await model.changePassword(_email, _password, _code);
      UIHelper.hideProgressDialog;
      if (_resp.isSuccess) {
        UIHelper.showSimpleDialog(
          'Mật khẩu đã được thay đổi',
          onTap: () => Navigator.pop(context),
        );
      } else {
        UIHelper.showSimpleDialog(_resp.errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: UIHelper.size20),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Images.BACK_GROUND), fit: BoxFit.fill),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: UIHelper.size20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ButtonWidget(
                      width: UIHelper.size50,
                      height: UIHelper.size50,
                      onTap: () => Navigator.of(context).pop(),
                      margin: EdgeInsets.only(top: UIHelper.paddingTop),
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: UIHelper.size15,
                            right: UIHelper.size15,
                            bottom: UIHelper.size15),
                        child: Image.asset(
                          Images.LEFT_ARROW,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Image.asset(
                            Images.LOGO,
                            width: UIHelper.size50,
                            height: UIHelper.size50,
                            fit: BoxFit.contain,
                          ),
                          UIHelper.horizontalSpaceMedium,
                          Text(
                            StringRes.APP_NAME,
                            style: textStyleAppName(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: BaseWidget<ForgotPasswordViewModel>(
                model: ForgotPasswordViewModel(api: Provider.of(context)),
                builder: (context, model, child) => Padding(
                  padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.isChangePassword
                              ? 'Đổi mật khẩu'
                              : 'Lấy mã xác thực',
                          style: textStyleBold(color: Colors.white),
                        ),
                        UIHelper.verticalSpaceLarge,
                        BorderTextFormField(
                          labelText: StringRes.EMAIL,
                          validator: Validator.validEmail,
                          onSaved: (value) => _email = value.trim(),
                        ),
                        model.isChangePassword
                            ? Column(
                                children: <Widget>[
                                  UIHelper.verticalSpaceMedium,
                                  BorderTextFormField(
                                    labelText: 'Mật khẩu mới',
                                    obscureText: true,
                                    validator: Validator.validPassword,
                                    onSaved: (value) =>
                                        _password = value.trim(),
                                  ),
                                  UIHelper.verticalSpaceMedium,
                                  BorderTextFormField(
                                    labelText: 'Mã xác thực',
                                    obscureText: true,
                                    validator: Validator.validCode,
                                    onSaved: (value) => _code = value.trim(),
                                  ),
                                ],
                              )
                            : Text(
                                'Một mã xác thực sẽ được gửi tới email mà bạn đã đăng ký. Vui lòng kiểm tra email và sử dụng mã xác thực để lấy lại mật khẩu',
                                style: textStyleItalic(color: Colors.white),
                              ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ButtonWidget(
                              margin: EdgeInsets.only(bottom: UIHelper.size30),
                              backgroundColor: PRIMARY,
                              child: Text(
                                model.isChangePassword
                                    ? 'ĐỔI MẬT KHẨU'
                                    : 'XÁC THỰC',
                                style: textStyleButton(),
                              ),
                              onTap: () {
                                if (validateAndSave()) {
                                  _handleSubmit(model);
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
