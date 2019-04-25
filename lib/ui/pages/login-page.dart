import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/blocs/login-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/input-widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/validator.dart';

class LoginPage extends BasePage<LoginBloc> with Validator {
  final _formKey = GlobalKey<FormState>();

  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildLoading(BuildContext context) => StreamBuilder<bool>(
        stream: pageBloc.loadingStream,
        builder: (c, snap) {
          bool isLoading = snap.hasData && snap.data;
          return LoadingWidget(
            show: isLoading,
          );
        },
      );

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_login.jpg'),
              fit: BoxFit.fill)),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    'assets/images/icn_logo.jpg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'FootballTeam',
                    style: TextStyle(
                        fontFamily: 'bold',
                        fontSize: 24,
                        letterSpacing: 0.1,
                        color: AppColor.GREEN),
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
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Đăng nhập',
                            style: Theme.of(context).textTheme.title.copyWith(
                                fontSize: 20,
                                color: AppColor.SECOND_BLACK,
                                fontFamily: 'bold'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputWidget(
                            validator: (value) {
                              if (value.isEmpty) return 'Vui lòng nhập email';
                              if (!validEmail(value))
                                return 'Email không hợp lệ';
                            },
                            labelText: 'Email',
                            onChangedText: (text) =>
                                pageBloc.changeEmailFunc(text),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputWidget(
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Vui lòng nhập mật khẩu';
                              if (!validPassword(value))
                                return 'Mật khẩu không hợp lệ (nhiều hơn 5 ký tự)';
                            },
                            labelText: 'Mật khẩu',
                            obscureText: true,
                            onChangedText: (text) =>
                                pageBloc.changePasswordFunc(text),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ButtonWidget(
                              margin: EdgeInsets.only(top: 10),
                              onTap: () {},
                              child: Text(
                                'Quên mật khẩu?',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        fontFamily: 'semi-bold',
                                        color: AppColor.GREEN),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ButtonWidget(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          pageBloc.submitLogin();
                        }
                      },
                      borderRadius: 5,
                      margin: EdgeInsets.only(top: 20, bottom: 30),
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 10),
                      backgroundColor: AppColor.GREEN,
                      child: Text(
                        'ĐĂNG NHẬP',
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: Colors.white),
                      ),
                    ),
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
                          'Social Login',
                          style: Theme.of(context).textTheme.body2.copyWith(
                              fontFamily: 'semi-bold', color: Colors.grey),
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
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        iconSize: 50,
                        onPressed: () => print('facebook'),
                        icon: Image.asset('assets/images/icn_facebook.png'),
                      ),
                      IconButton(
                        iconSize: 50,
                        onPressed: () => print('facebook'),
                        icon: Image.asset('assets/images/icn_google.png'),
                      )
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Bạn chưa có tài khoản? ',
                            style: TextStyle(
                                fontFamily: 'semi-bold',
                                color: AppColor.MAIN_BLACK,
                                fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Đăng ký ngay',
                                  style: TextStyle(
                                      fontFamily: 'semi-bold',
                                      color: AppColor.GREEN,
                                      fontSize: 16),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('signup');
                                    }),
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
  BaseBloc initPageBloc(BuildContext context) {
    pageBloc = BlocProvider.of<LoginBloc>(context);
    pageBloc.loginEmailStream.listen((response) {
      if (!response.success) {
        
      }
    });
    return pageBloc;
  }

  @override
  bool showFullScreen() => true;
}
