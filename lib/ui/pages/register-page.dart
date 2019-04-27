import 'package:flutter/material.dart';
import 'package:myfootball/blocs/register-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/input-widget.dart';
import 'package:myfootball/utils/validator.dart';

class RegisterPage extends BasePage<RegisterBloc> with Validator {
  final _formKey = GlobalKey<FormState>();

  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

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
                            'Đăng ký',
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
                              if (value.isEmpty)
                                return 'Vui lòng nhập tên người dùng';
                            },
                            labelText: 'Tên người dùng',
                            inputAction: TextInputAction.next,
                            onChangedText: (text) =>
                                pageBloc.changeUsernameFunc(text),
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
                            inputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.next,
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
                            inputAction: TextInputAction.next,
                            onChangedText: (text) =>
                                pageBloc.changePasswordFunc(text),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputWidget(
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Vui lòng nhập số điện thoại';
                              if (!validPhoneNumber(value))
                                return 'Số điện thoại không hợp lệ';
                            },
                            labelText: 'Số điện thoại',
                            inputType: TextInputType.phone,
                            inputAction: TextInputAction.done,
                            onChangedText: (text) =>
                                pageBloc.changePhoneNumberFunc(text),
                          ),
                          SizedBox(
                            height: 10,
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
                            pageBloc.submitRegisterFunc(true);
                          }
                        },
                        borderRadius: 5,
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        backgroundColor: AppColor.GREEN,
                        child: Text(
                          'ĐĂNG KÝ',
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
    pageBloc.registerStream.listen((data) {
      if (!data.success) {
        showSnackBar(data.errorMessage);
      } else {
        showSimpleDialog(context, data.errorMessage,
            onTap: () => Navigator.of(context).pop());
      }
    });
  }

  @override
  bool showFullScreen() => true;

  @override
  void listenAppData(BuildContext context) {}
}
