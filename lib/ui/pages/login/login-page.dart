import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/border_textformfield.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/utils/validator.dart';
import 'package:myfootball/viewmodels/login_view_model.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  String _email;
  String _password;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
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
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          UIHelper.verticalSpaceLarge,
                          BorderTextFormField(
                            labelText: StringRes.EMAIL,
                            controller: _emailCtrl,
                            validator: Validator.validEmail,
                            onSaved: (value) => _email = value.trim(),
                          ),
                          UIHelper.verticalSpaceMedium,
                          BorderTextFormField(
                            labelText: StringRes.PASSWORD,
                            controller: _passwordCtrl,
                            validator: Validator.validPassword,
                            obscureText: true,
                            onSaved: (value) => _password = value.trim(),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () =>
                                  Routes.routeToForgotPassword(context),
                              child: Text(
                                'Quên mật khẩu?',
                                style: textStyleRegular(color: Colors.white),
                              ),
                            ),
                          ),
                          BaseWidget<LoginViewModel>(
                            model: LoginViewModel(
                                authServices: Provider.of(context)),
                            builder: (context, model, child) => ButtonWidget(
                              margin: EdgeInsets.symmetric(
                                  vertical: UIHelper.size30),
                              backgroundColor: PRIMARY,
                              child: Text(
                                StringRes.LOGIN.toUpperCase(),
                                style: textStyleButton(),
                              ),
                              onTap: () async {
                                if (validateAndSave()) {
                                  UIHelper.showProgressDialog;
                                  var _loginResp =
                                      await model.loginEmail(_email, _password);
                                  if (_loginResp.isSuccess) {
                                    var _registerDeviceResp =
                                        await model.registerDevice();
                                    UIHelper.hideProgressDialog;
                                    if (_registerDeviceResp.isSuccess) {
                                     Routes.routeToHome(context);
                                    } else {
                                      UIHelper.showSimpleDialog(context,
                                          _registerDeviceResp.errorMessage);
                                    }
                                  } else {
                                    UIHelper.hideProgressDialog;
                                    UIHelper.showSimpleDialog(
                                        context, _loginResp.errorMessage);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 1,
                          color: LINE_COLOR,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
                        child: Text(
                          StringRes.LOGIN_VIA,
                          style: textStyleRegular(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: LINE_COLOR,
                        ),
                      )
                    ],
                  ),
                  UIHelper.verticalSpaceLarge,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        iconSize: UIHelper.size40,
                        onPressed: () => print('facebook'),
                        icon: Image.asset('assets/images/icn_facebook.png'),
                      ),
                      IconButton(
                        iconSize: UIHelper.size40,
                        onPressed: () => print('google'),
                        icon: Image.asset('assets/images/icn_google.png'),
                      )
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'Bạn chưa có tài khoản? ',
                          style: TextStyle(
                              color: Colors.white, fontSize: UIHelper.size(16)),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Đăng ký ngay',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: SEMI_BOLD,
                                    color: Colors.white,
                                    fontSize: UIHelper.size(18)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => Routes.routeToRegister(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
