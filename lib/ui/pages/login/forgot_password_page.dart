import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/light_input_text.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/utils/validator.dart';
import 'package:myfootball/viewmodels/forgotpassword_viewmodel.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _code;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: UIHelper.size50,
                        height: UIHelper.size50,
                        margin: EdgeInsets.only(top: UIHelper.paddingTop),
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => NavigationService.instance.goBack(),
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
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: BaseWidget<ForgotPasswordViewModel>(
                  model: ForgotPasswordViewModel(api: Provider.of(context)),
                  builder: (context, model, child) => Padding(
                    padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: UIHelper.size25),
                            child: Text(
                              model.isChangePassword
                                  ? 'Đổi mật khẩu'
                                  : 'Lấy mã xác thực',
                              style: textStyleBold(color: PRIMARY),
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                          LightInputTextWidget(
                            labelText: 'Email',
                            validator: Validator.validEmail,
                            inputType: TextInputType.emailAddress,
                            onSaved: (value) => _email = value.trim(),
                          ),
                          model.isChangePassword
                              ? Column(
                                  children: <Widget>[
                                    UIHelper.verticalSpaceMedium,
                                    LightInputTextWidget(
                                      labelText: 'Mật khẩu mới',
                                      obscureText: true,
                                      validator: Validator.validPassword,
                                      onSaved: (value) =>
                                          _password = value.trim(),
                                    ),
                                    UIHelper.verticalSpaceMedium,
                                    LightInputTextWidget(
                                      labelText: 'Mã xác thực',
                                      obscureText: true,
                                      validator: Validator.validCode,
                                      onSaved: (value) => _code = value.trim(),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: UIHelper.size10),
                            child: Text(
                              'Mã xác thực ${model.isChangePassword ? 'đã' : 'sẽ'} được gửi tới email mà bạn đã đăng ký. Vui lòng kiểm tra email và sử dụng mã xác thực để lấy lại mật khẩu',
                              style: textStyleItalic(color: Colors.black87),
                            ),
                          ),
                          ButtonWidget(
                            child: Text(
                              model.isChangePassword
                                  ? 'ĐỔI MẬT KHẨU'
                                  : 'XÁC THỰC',
                              style: textStyleButton(),
                            ),
                            margin: EdgeInsets.only(
                                top: UIHelper.size40,
                                bottom: UIHelper.paddingBottom + UIHelper.size20),
                            onTap: () {
                              if (validateAndSave()) {
                                if (model.isChangePassword) {
                                  model.changePassword(_email, _password, _code);
                                } else {
                                  model.forgotPassword(_email);
                                }
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
