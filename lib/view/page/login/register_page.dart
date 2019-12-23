import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/stringres.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/light_input_text.dart';
import 'package:myfootball/view/widget/button_widget.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/utils/validator.dart';
import 'package:myfootball/viewmodel/register_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _phone;
  String _email;
  String _password;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  handleRegister(RegisterViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.registerWithEmail(
        _name, _email, _password, _phone, [Constants.TEAM_LEADER]);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog(
          'Đăng ký thành công! Một mã xác thực gồm 6 ký tự sẽ được gửi đến số điện thoại của bạn. Vui lòng nhập mã xác thực để kích hoạt tài khoản',
          isSuccess: true,
          onConfirmed: () =>
              model.verifyPhoneNumber(resp.user.id, resp.user.phone));
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => UIHelper.hideKeyBoard(),
        child: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                child: Image.asset(
                  Images.BACKGROUND,
                  fit: BoxFit.cover,
                  width: UIHelper.screenWidth,
                  height: UIHelper.screenHeight,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: UIHelper.screenHeight * 0.25,
                  padding: EdgeInsets.only(
                      bottom: UIHelper.size35,
                      left: UIHelper.size20,
                      right: UIHelper.size20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: UIHelper.size50,
                        height: UIHelper.size50,
                        margin: EdgeInsets.only(top: UIHelper.paddingTop),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: UIHelper.size15,
                                right: UIHelper.size15,
                                bottom: UIHelper.size15),
                            child: Image.asset(
                              Images.LEFT_ARROW,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
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
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: UIHelper.screenHeight * 0.25,
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: UIHelper.size20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: UIHelper.size10, bottom: UIHelper.size25),
                        child: Text(
                          'Đăng ký',
                          style: textStyleBold(color: PRIMARY),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: UIHelper.size10),
                                  child: LightInputTextWidget(
                                    labelText: 'Tên đầy đủ',
                                    validator: Validator.validName,
                                    onSaved: (value) => _name = value.trim(),
                                  ),
                                ),
                                LightInputTextWidget(
                                  labelText: 'Số điện thoại',
                                  validator: Validator.validPhoneNumber,
                                  inputType: TextInputType.phone,
                                  formatter: [
                                    MaskTextInputFormatter(
                                        mask: '*### ### ###',
                                        filter: {
                                          "#": RegExp(r'[0-9]'),
                                          "*": RegExp(r'[0]')
                                        })
                                  ],
                                  onSaved: (value) => _phone = value.trim(),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: UIHelper.size10),
                                  child: LightInputTextWidget(
                                    labelText: 'Email',
                                    validator: Validator.validEmail,
                                    inputType: TextInputType.emailAddress,
                                    onSaved: (value) => _email = value.trim(),
                                  ),
                                ),
                                LightInputTextWidget(
                                  labelText: 'Mật khẩu',
                                  obscureText: true,
                                  validator: Validator.validPassword,
                                  onSaved: (value) => _password = value.trim(),
                                ),
                                BaseWidget<RegisterViewModel>(
                                  model: RegisterViewModel(
                                      api: Provider.of(context)),
                                  builder: (context, model, child) =>
                                      ButtonWidget(
                                    margin: EdgeInsets.only(
                                        top: UIHelper.size40,
                                        bottom: UIHelper.paddingBottom +
                                            UIHelper.size20),
                                    child: Text(
                                      'ĐĂNG KÝ',
                                      style: textStyleButton(),
                                    ),
                                    onTap: () {
                                      if (validateAndSave()) {
                                        handleRegister(model);
                                      }
                                    },
                                  ),
                                )
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
