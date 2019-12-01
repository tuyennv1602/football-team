import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/widgets/light_input_text.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/utils/validator.dart';
import 'package:myfootball/viewmodels/login_viewmodel.dart';
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
      body: GestureDetector(
        onTap: () => UIHelper.hideKeyBoard(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: UIHelper.size20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.BACKGROUND),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: UIHelper.size35),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        Images.LOGO,
                        width: UIHelper.size50,
                        height: UIHelper.size50,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: UIHelper.size15),
                        child: Text(
                          StringRes.APP_NAME,
                          style: textStyleAppName(),
                        ),
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
                            LightInputTextWidget(
                              labelText: 'Email',
                              validator: Validator.validEmail,
                              inputType: TextInputType.emailAddress,
                              onSaved: (value) => _email = value.trim(),
                            ),
                            UIHelper.verticalSpaceMedium,
                            LightInputTextWidget(
                              labelText: 'Mật khẩu',
                              validator: Validator.validPassword,
                              obscureText: true,
                              onSaved: (value) => _password = value.trim(),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () => NavigationService.instance
                                    .navigateTo(FORGOT_PASSWORD),
                                child: Text(
                                  'Quên mật khẩu?',
                                  style: textStyleAlert(
                                      color: Colors.black, size: 17),
                                ),
                              ),
                            ),
                            BaseWidget<LoginViewModel>(
                              model: LoginViewModel(
                                  authServices: Provider.of(context)),
                              onModelReady: (model) => model.setupDeviceInfo(),
                              builder: (context, model, child) => ButtonWidget(
                                margin: EdgeInsets.symmetric(
                                    vertical: UIHelper.size30),
                                child: Text(
                                  'ĐĂNG NHẬP',
                                  style: textStyleButton(),
                                ),
                                onTap: () {
                                  if (validateAndSave()) {
                                    model.loginEmail(_email, _password);
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
                          padding:
                              EdgeInsets.symmetric(horizontal: UIHelper.size10),
                          child: Text(
                            'Đăng nhập qua',
                            style: textStyleRegular(),
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
                          icon: Image.asset('assets/images/ic_facebook.png'),
                        ),
                        IconButton(
                          iconSize: UIHelper.size40,
                          onPressed: () => print('google'),
                          icon: Image.asset('assets/images/ic_google.png'),
                        )
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Bạn chưa có tài khoản? ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: UIHelper.size(17))),
                              TextSpan(
                                  text: 'Đăng ký',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontFamily: BOLD,
                                      color: PRIMARY,
                                      fontSize: UIHelper.size(17)),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => NavigationService.instance
                                        .navigateTo(REGISTER)),
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
      ),
    );
  }
}
