import 'package:flutter/material.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/border_textformfield.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/utils/validator.dart';
import 'package:myfootball/viewmodels/register_viewmodel.dart';
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

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: UIHelper.size20),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Images.BACKGROUND), fit: BoxFit.fill),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: UIHelper.screenHeight,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: UIHelper.size20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ButtonWidget(
                          width: UIHelper.size50,
                          height: UIHelper.size50,
                          onTap: () => Navigator.of(context).pop(),
                          margin: EdgeInsets.only(top: UIHelper.paddingTop),
                          backgroundColor: Colors.transparent,
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
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Image.asset(
                                Images.LOGO,
                                width: UIHelper.size50,
                                height: UIHelper.size50,
                                fit: BoxFit.contain,
                              ),
                              UIHelper.horizontalSpaceMedium,
                              Text(
                                StringRes.APP_NAME,
                                style: textStyleAppName(),
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
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: UIHelper.size10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                StringRes.REGISTER,
                                style: textStyleBold(color: Colors.white),
                              ),
                              UIHelper.verticalSpaceLarge,
                              BorderTextFormField(
                                labelText: StringRes.USER_NAME,
                                validator: Validator.validName,
                                onSaved: (value) => _name = value.trim(),
                              ),
                              UIHelper.verticalSpaceMedium,
                              BorderTextFormField(
                                labelText: StringRes.EMAIL,
                                validator: Validator.validEmail,
                                inputType: TextInputType.emailAddress,
                                onSaved: (value) => _email = value.trim(),
                              ),
                              UIHelper.verticalSpaceMedium,
                              BorderTextFormField(
                                labelText: StringRes.PHONE,
                                validator: Validator.validPhoneNumber,
                                inputType: TextInputType.phone,
                                onSaved: (value) => _phone = value.trim(),
                              ),
                              UIHelper.verticalSpaceMedium,
                              BorderTextFormField(
                                labelText: StringRes.PASSWORD,
                                obscureText: true,
                                validator: Validator.validPassword,
                                onSaved: (value) => _password = value.trim(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: BaseWidget<RegisterViewModel>(
                            model: RegisterViewModel(api: Provider.of(context)),
                            builder: (context, model, child) => ButtonWidget(
                              margin: EdgeInsets.only(bottom: UIHelper.size30),
                              child: Text(
                                StringRes.REGISTER.toUpperCase(),
                                style: textStyleButton(),
                              ),
                              onTap: () {
                                if (validateAndSave()) {
                                  model.registerWithEmail(
                                      _name,
                                      _email,
                                      _password,
                                      _phone,
                                      [Constants.TEAM_LEADER]);
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
