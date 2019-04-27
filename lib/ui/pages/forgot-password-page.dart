import 'package:flutter/material.dart';
import 'package:myfootball/blocs/forgot-password-bloc.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/input-widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/validator.dart';

class ForgotPasswordPage extends BasePage<ForgotPasswordBloc> with Validator {
  final _formKey = GlobalKey<FormState>();

  @override
  AppBarWidget buildAppBar(BuildContext context) => null;

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
                            'Quên mật khẩu',
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
                            labelText: 'Mật khẩu mới',
                            obscureText: true,
                            onChangedText: (text) =>
                                pageBloc.changePasswordFunc(text),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputWidget(
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Vui lòng nhập mã xác nhận';
                            },
                            labelText: 'Mã xác nhận',
                            onChangedText: (text) =>
                                pageBloc.changeCodeFunc(text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ButtonWidget(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: 5,
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        backgroundColor: Colors.grey,
                        child: Text(
                          'QUAY LẠI',
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      ButtonWidget(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            pageBloc.submitEmailFunc(true);
                          }
                        },
                        borderRadius: 5,
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        backgroundColor: AppColor.GREEN,
                        child: Text(
                          'XÁC NHẬN',
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  @override
  void listenPageData(BuildContext context) {
    pageBloc.submitEmailStream.listen((onData) {
      if (!onData.success) {
        showSnackBar(onData.errorMessage);
      }
    });
  }

  @override
  bool showFullScreen() => true;

  @override
  void listenAppData(BuildContext context) {
  }
}