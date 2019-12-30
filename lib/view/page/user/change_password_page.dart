import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/utils/validator.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/customize_button.dart';
import 'package:myfootball/view/widget/input_text.dart';
import 'package:myfootball/view/widget/circle_input_text.dart';
import 'package:myfootball/viewmodel/forgotpassword_viewmodel.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChangePasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final email;
  String _password;
  String _code;

  ChangePasswordPage({Key key, this.email}) : super(key: key);

  validateAndSave() {
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
      backgroundColor: PRIMARY,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          CustomizeAppBar(
            centerContent: Text(
              'Đổi mật khẩu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButton(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: Padding(
                padding: EdgeInsets.all(UIHelper.padding),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              InputText(
                                labelText: 'Mật khẩu mới',
                                obscureText: true,
                                validator: Validator.validPassword,
                                onSaved: (value) => _password = value.trim(),
                              ),
                              InputText(
                                labelText: 'Mã xác thực',
                                validator: Validator.validCode,
                                onSaved: (value) => _code = value.trim(),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: UIHelper.size10),
                            child: Text(
                              'Mã xác thực đã được gửi tới email mà bạn đã đăng ký. Vui lòng kiểm tra email và sử dụng mã xác thực để lấy đổi mật khẩu',
                              style: textStyleItalic(color: Colors.black87),
                            ),
                          ),
                          BaseWidget<ForgotPasswordViewModel>(
                            model: ForgotPasswordViewModel(
                                api: Provider.of(context)),
                            builder: (c, model, child) => CustomizeButton(
                              child: Text(
                                'ĐỔI MẬT KHẨU',
                                style: textStyleButton(),
                              ),
                              margin: EdgeInsets.only(
                                  top: UIHelper.size40,
                                  bottom:
                                      UIHelper.paddingBottom + UIHelper.size20),
                              onTap: () {
                                if (validateAndSave()) {
                                  model.changePassword(email, _password, _code);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
