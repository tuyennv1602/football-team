import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/fonts.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/stringres.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/widget/circle_input_text.dart';
import 'package:myfootball/view/widget/button_widget.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/utils/validator.dart';
import 'package:myfootball/viewmodel/login_vm.dart';
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
                child: BaseWidget<LoginViewModel>(
                  model: LoginViewModel(authServices: Provider.of(context)),
                  onModelReady: (model) => model.setupDeviceInfo(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: UIHelper.size20, bottom: UIHelper.size10),
                            child: CircleInputText(
                              labelText: 'Email',
                              validator: Validator.validEmail,
                              inputType: TextInputType.emailAddress,
                              onSaved: (value) => _email = value.trim(),
                            ),
                          ),
                          CircleInputText(
                            labelText: 'Mật khẩu',
                            validator: Validator.validPassword,
                            obscureText: true,
                            onSaved: (value) => _password = value.trim(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  builder: (c, model, child) => Column(
                    children: <Widget>[
                      child,
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () =>
                              Navigation.instance.navigateTo(FORGOT_PASSWORD),
                          child: Text(
                            'Quên mật khẩu?',
                            style:
                                textStyleAlert(color: Colors.black, size: 17),
                          ),
                        ),
                      ),
                      ButtonWidget(
                        margin: EdgeInsets.symmetric(vertical: UIHelper.size30),
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 1,
                              color: LINE_COLOR,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: UIHelper.size10),
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
                      Padding(
                        padding: EdgeInsets.only(top: UIHelper.size20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              iconSize: UIHelper.size45,
                              onPressed: () => model.loginFacebook(),
                              icon:
                                  Image.asset('assets/images/ic_facebook.png'),
                            ),
                            IconButton(
                              iconSize: UIHelper.size45,
                              onPressed: () => model.loginGoogle(),
                              icon: Image.asset('assets/images/ic_google.png'),
                            )
                          ],
                        ),
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
                                      ..onTap = () => Navigation.instance
                                          .navigateTo(REGISTER)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
