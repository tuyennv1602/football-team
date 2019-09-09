import 'package:flutter/material.dart';
import 'package:myfootball/blocs/register-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/input-widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/device-util.dart';
import 'package:myfootball/utils/validator.dart';

// ignore: must_be_immutable
class RegisterPage extends BasePage<RegisterBloc> with Validator {
  final _formKey = GlobalKey<FormState>();

  @override
  AppBarWidget buildAppBar(BuildContext context) => null;

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ButtonWidget(
                        width: 50,
                        height: 50,
                        onTap: () => Navigator.of(context).pop(),
                        margin: EdgeInsets.only(
                            top: DeviceUtil.getPaddingTop(context)),
                        backgroundColor: AppColor.TRANSPARENT,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 12, right: 12, bottom: 12),
                          child: Image.asset(
                            Images.LEFT_ARROW,
                            color: AppColor.WHITE,
                          ),
                        ),
                      ),
                      Expanded(
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
                                StringRes.REGISTER,
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(
                                        fontSize: 20,
                                        color: AppColor.GREEN,
                                        fontFamily: 'bold'),
                              ),
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty)
                                    return StringRes.USER_NAME_REQUIRED;
                                  return null;
                                },
                                labelText: StringRes.USER_NAME,
                                inputAction: TextInputAction.next,
                                onChangedText: (text) =>
                                    pageBloc.changeUsernameFunc(text),
                              ),
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty)
                                    return StringRes.REQUIRED_EMAIL;
                                  if (!validEmail(value))
                                    return StringRes.EMAIL_INVALID;
                                  return null;
                                },
                                inputType: TextInputType.emailAddress,
                                inputAction: TextInputAction.next,
                                labelText: StringRes.EMAIL,
                                onChangedText: (text) =>
                                    pageBloc.changeEmailFunc(text),
                              ),
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty)
                                    return StringRes.REQUIRED_PASSWORD;
                                  if (!validPassword(value))
                                    return StringRes.PASSWORD_INVALID;
                                  return null;
                                },
                                labelText: StringRes.PASSWORD,
                                obscureText: true,
                                inputAction: TextInputAction.next,
                                onChangedText: (text) =>
                                    pageBloc.changePasswordFunc(text),
                              ),
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty)
                                    return StringRes.REQUIRED_PHONE;
                                  if (!validPhoneNumber(value))
                                    return StringRes.PHONE_INVALID;
                                  return null;
                                },
                                labelText: StringRes.PHONE,
                                inputType: TextInputType.phone,
                                inputAction: TextInputAction.done,
                                onChangedText: (text) =>
                                    pageBloc.changePhoneNumberFunc(text),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        child: ButtonWidget(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              pageBloc.submitRegisterFunc(true);
                            } else {
                              hideKeyBoard(context);
                            }
                          },
                          borderRadius: BorderRadius.circular(5),
                          margin: EdgeInsets.only(top: 25, bottom: 25),
                          backgroundColor: AppColor.GREEN,
                          child: Text(
                            StringRes.REGISTER.toUpperCase(),
                            style: Theme.of(context).textTheme.body2,
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void listenData(BuildContext context) {
    pageBloc.registerStream.listen((data) {
      if (!data.isSuccess) {
        showSnackBar(data.errorMessage);
      } else {
        showSimpleDialog(context, data.errorMessage,
            onTap: () => Navigator.of(context).pop());
      }
    });
  }

  @override
  bool get showFullScreen => true;

  @override
  bool get resizeAvoidPadding => true;
}
