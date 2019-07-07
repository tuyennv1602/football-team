import 'package:flutter/material.dart';
import 'package:myfootball/blocs/forgot-password-bloc.dart';
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
          image:
              DecorationImage(image: AssetImage('assets/images/bg_login.jpg'), fit: BoxFit.fill)),
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
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          StreamBuilder<bool>(
                            stream: pageBloc.changeTypeStream,
                            builder: (c, snap) => Text(
                                  (snap.hasData && snap.data) ? 'Đổi mật khẩu' : 'Lấy mã xác nhận',
                                  style: Theme.of(context).textTheme.title.copyWith(
                                      fontSize: 20, color: AppColor.GREEN, fontFamily: 'bold'),
                                ),
                          ),
                          InputWidget(
                            validator: (value) {
                              if (value.isEmpty) return 'Vui lòng nhập email';
                              if (!validEmail(value)) return 'Email không hợp lệ';
                            },
                            labelText: 'Email',
                            onChangedText: (text) => pageBloc.changeEmailFunc(text),
                          ),
                          StreamBuilder<bool>(
                            stream: pageBloc.changeTypeStream,
                            builder: (c, snap) {
                              if (snap.hasData && snap.data) {
                                return Column(
                                  children: <Widget>[
                                    InputWidget(
                                      validator: (value) {
                                        if (value.isEmpty) return 'Vui lòng nhập mật khẩu';
                                        if (!validPassword(value))
                                          return 'Mật khẩu không hợp lệ (nhiều hơn 5 ký tự)';
                                      },
                                      labelText: 'Mật khẩu mới',
                                      obscureText: true,
                                      onChangedText: (text) => pageBloc.changePasswordFunc(text),
                                    ),
                                    InputWidget(
                                      validator: (value) {
                                        if (value.isEmpty) return 'Vui lòng nhập mã xác nhận';
                                      },
                                      labelText: 'Mã xác nhận',
                                      onChangedText: (text) => pageBloc.changeCodeFunc(text),
                                    )
                                  ],
                                );
                              }
                              return Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Một mã xác nhận sẽ được gửi đến email của bạn. Vui lòng kiểm tra email và sử dụng mã xác nhận để thay đổi mật khẩu",
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .copyWith(fontFamily: 'italic', color: Colors.grey),
                                ),
                              );
                            },
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
                        borderRadius: BorderRadius.circular(5),
                        width: 150,
                        height: 40,
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        backgroundColor: Colors.grey,
                        child: Text(
                          'QUAY LẠI',
                          style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
                        ),
                      ),
                      ButtonWidget(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            pageBloc.submit();
                          }
                        },
                        borderRadius: BorderRadius.circular(5),
                        width: 150,
                        height: 40,
                        margin: EdgeInsets.only(top: 25, bottom: 25),
                        backgroundColor: AppColor.GREEN,
                        child: Text(
                          'XÁC NHẬN',
                          style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
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
      } else {
        showSnackBar(onData.errorMessage, backgroundColor: AppColor.GREEN);
        pageBloc.changeTypeFunc(true);
      }
    });
    pageBloc.submitChangePasswordStream.listen((onData) {
      if (!onData.success) {
        showSnackBar(onData.errorMessage);
      } else {
        showSnackBar('Password was changed', backgroundColor: AppColor.GREEN);
        Future.delayed(Duration(milliseconds: 5000), () => Navigator.of(context).pop());
      }
    });
  }

  @override
  bool get showFullScreen => true;

  @override
  void listenAppData(BuildContext context) {}
}
