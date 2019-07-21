import 'package:flutter/material.dart';
import 'package:myfootball/blocs/register-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/constants.dart';
import 'package:myfootball/res/strings.dart';
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

  Widget _buildItemRole(BuildContext context, int value, List<int> groupValue, String title) {
    bool isSelected = groupValue.contains(value);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: isSelected,
          activeColor: AppColor.GREEN,
          onChanged: (isChecked) {
            if (isChecked) {
              groupValue.add(value);
            } else {
              groupValue.remove(value);
            }
            if (groupValue.length == 0) {
              groupValue.add(Constants.TEAM_MEMBER);
            }
            pageBloc.changeRoleFunc(groupValue);
          },
        ),
        Text(
          title,
          style: TextStyle(
              fontFamily: isSelected ? 'semi-bold' : 'regular',
              fontSize: 16,
              color: isSelected ? AppColor.GREEN : AppColor.MAIN_BLACK),
        )
      ],
    );
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage('assets/images/bg_login.jpg'), fit: BoxFit.cover)),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
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
                        Strings.APP_NAME,
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
                            color: Colors.white, borderRadius: BorderRadius.circular(5)),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Strings.REGISTER,
                                style: Theme.of(context).textTheme.title.copyWith(
                                    fontSize: 20, color: AppColor.GREEN, fontFamily: 'bold'),
                              ),
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty) return Strings.USER_NAME_REQUIRED;
                                  return null;
                                },
                                labelText: Strings.USER_NAME,
                                inputAction: TextInputAction.next,
                                onChangedText: (text) => pageBloc.changeUsernameFunc(text),
                              ),
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty) return Strings.REQUIRED_EMAIL;
                                  if (!validEmail(value)) return Strings.EMAIL_INVALID;
                                  return null;
                                },
                                inputType: TextInputType.emailAddress,
                                inputAction: TextInputAction.next,
                                labelText: Strings.EMAIL,
                                onChangedText: (text) => pageBloc.changeEmailFunc(text),
                              ),
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty) return Strings.REQUIRED_PASSWORD;
                                  if (!validPassword(value)) return Strings.PASSWORD_INVALID;
                                  return null;
                                },
                                labelText: Strings.PASSWORD,
                                obscureText: true,
                                inputAction: TextInputAction.next,
                                onChangedText: (text) => pageBloc.changePasswordFunc(text),
                              ),
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty) return Strings.REQUIRED_PHONE;
                                  if (!validPhoneNumber(value)) return Strings.PHONE_INVALID;
                                  return null;
                                },
                                labelText: Strings.PHONE,
                                inputType: TextInputType.phone,
                                inputAction: TextInputAction.done,
                                onChangedText: (text) => pageBloc.changePhoneNumberFunc(text),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<List<int>>(
                                stream: pageBloc.changeRoleStream,
                                builder: (c, snap) {
                                  var groupValue = snap.hasData ? snap.data : [1];
                                  print(groupValue);
                                  return Column(
                                    children: <Widget>[
                                      _buildItemRole(context, Constants.TEAM_MEMBER, groupValue,
                                          'Thành viên đội bóng'),
                                      _buildItemRole(context, Constants.GROUND_OWNER, groupValue,
                                          'Quản lý sân bóng'),
                                    ],
                                  );
                                },
                              )
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
                            margin: EdgeInsets.only(top: 30, bottom: 30),
                            width: 150,
                            height: 40,
                            backgroundColor: Colors.grey,
                            child: Text(
                              Strings.BACK,
                              style:
                                  Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
                            ),
                          ),
                          ButtonWidget(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                pageBloc.submitRegisterFunc(true);
                              } else {
                                hideKeyBoard(context);
                              }
                            },
                            borderRadius: BorderRadius.circular(5),
                            width: 150,
                            height: 40,
                            margin: EdgeInsets.only(top: 25, bottom: 25),
                            backgroundColor: AppColor.GREEN,
                            child: Text(
                              Strings.REGISTER.toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
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
      if (!data.success) {
        showSnackBar(data.errorMessage);
      } else {
        showSimpleDialog(context, data.errorMessage, onTap: () => Navigator.of(context).pop());
      }
    });
  }

  @override
  bool get showFullScreen => true;

  @override
  bool get resizeAvoidPadding => true;
}
