import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/blocs/login-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/input-widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/validator.dart';

// ignore: must_be_immutable
class LoginPage extends BasePage<LoginBloc> with Validator {
  final _formKey = GlobalKey<FormState>();

  @override
  AppBarWidget buildAppBar(BuildContext context) => null;


  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.fill)),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    'assets/images/icn_logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    StringRes.APP_NAME,
                    style: TextStyle(
                        fontFamily: 'bold',
                        fontSize: 24,
                        letterSpacing: 0.1,
                        color: AppColor.WHITE),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringRes.LOGIN,
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 20, color: AppColor.GREEN, fontFamily: 'bold'),
                          ),
                          InputWidget(
                            validator: (value) {
                              if (value.isEmpty) return StringRes.REQUIRED_EMAIL;
                              if (!validEmail(value)) return StringRes.EMAIL_INVALID;
                              return null;
                            },
                            labelText: StringRes.EMAIL,
                            onChangedText: (text) => pageBloc.changeEmailFunc(text),
                          ),
                          InputWidget(
                            validator: (value) {
                              if (value.isEmpty) return StringRes.REQUIRED_PASSWORD;
                              if (!validPassword(value)) return StringRes.PASSWORD_INVALID;
                              return null;
                            },
                            labelText: StringRes.PASSWORD,
                            obscureText: true,
                            onChangedText: (text) => pageBloc.changePasswordFunc(text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ButtonWidget(
                        backgroundColor: AppColor.TRANSPARENT,
                        onTap: () => Routes.routeToForgotPasswordPage(context),
                        child: Text(
                          StringRes.FORGOT_PASSWORD,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      ButtonWidget(
                        width: 200,
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            pageBloc.submitLoginEmailFunc(true);
                          }
                        },
                        borderRadius: BorderRadius.circular(5),
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        backgroundColor: AppColor.GREEN,
                        child: Text(
                          StringRes.LOGIN.toUpperCase(),
                          style: Theme.of(context).textTheme.body2,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColor.LINE_COLOR,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          StringRes.LOGIN_VIA,
                          style: Theme.of(context).textTheme.body1.copyWith(color: AppColor.WHITE),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColor.LINE_COLOR,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        iconSize: 45,
                        onPressed: () => showConfirmDialog(context, "data.errorMessage",
                            onConfirmed: () => Navigator.of(context).pop()),
                        icon: Image.asset('assets/images/icn_facebook.png'),
                      ),
                      IconButton(
                        iconSize: 45,
                        onPressed: () => print('google'),
                        icon: Image.asset('assets/images/icn_google.png'),
                      )
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Bạn chưa có tài khoản? ',
                            style: TextStyle(color: AppColor.WHITE, fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Đăng ký ngay',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'semi-bold',
                                      color: AppColor.WHITE,
                                      fontSize: 16),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Routes.routeToRegisterPage(context)),
                            ]),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  void listenData(BuildContext context) {
    pageBloc.loginEmailStream.listen((response) {
      if (!response.isSuccess) {
        showSnackBar(response.errorMessage);
      } else {
        appBloc.updateUser();
        Routes.routeToHomePage(context);
      }
    });
  }

  @override
  bool get showFullScreen => true;
}
