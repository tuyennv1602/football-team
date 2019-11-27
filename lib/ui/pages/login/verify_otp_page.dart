import 'package:flutter/material.dart';
import 'package:myfootball/models/verify_arg.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/count_down_timer.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/verify_otp_viewmodel.dart';
import 'package:provider/provider.dart';

class VerifyOTPPage extends StatelessWidget {
  final VerifyArgument verifyArgument;

  VerifyOTPPage({Key key, @required this.verifyArgument}) : super(key: key);

  Widget _buildItemCode(String code) => Container(
        height: UIHelper.size40,
        width: UIHelper.size35,
        margin: EdgeInsets.symmetric(horizontal: UIHelper.size(8)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: code.isEmpty ? Colors.grey : PRIMARY, width: 2)),
        ),
        child: Text(
          code,
          maxLines: 1,
          style: textStyleBold(color: PRIMARY, size: 24),
        ),
      );

  Widget _buildItemNumber(String title, {Function onTap}) => ButtonWidget(
        onTap: onTap,
        elevation: 2,
        backgroundColor: Colors.white,
        child: Text(
          title,
          style: textStyleSemiBold(size: 24),
          textAlign: TextAlign.center,
        ),
      );

  getCodeFromIndex(String otpCode, int index) {
    if (otpCode.length > index) {
      return otpCode.substring(index, index + 1);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.BACKGROUND),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: UIHelper.size35,
                    left: UIHelper.size25,
                    right: UIHelper.size25),
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
            Expanded(
              flex: 3,
              child: BaseWidget<VerifyOTPViewModel>(
                model: VerifyOTPViewModel(api: Provider.of(context)),
                builder: (c, model, child) {
                  var otpCode = model.otpCode;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: UIHelper.size10,
                            bottom: UIHelper.size25,
                            left: UIHelper.size20,
                            right: UIHelper.size20),
                        child: Text(
                          'Kích hoạt tài khoản',
                          style: textStyleBold(color: PRIMARY),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: UIHelper.size20),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    'Vui lòng nhập mã xác thực đã được gửi đến số điện thoại ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: REGULAR,
                                  fontSize: UIHelper.size(17),
                                ),
                              ),
                              TextSpan(
                                text: verifyArgument.phoneNumber,
                                style: TextStyle(
                                  fontFamily: BOLD,
                                  color: Colors.black,
                                  fontSize: UIHelper.size(17),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: UIHelper.size20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildItemCode(getCodeFromIndex(otpCode, 0)),
                            _buildItemCode(getCodeFromIndex(otpCode, 1)),
                            _buildItemCode(getCodeFromIndex(otpCode, 2)),
                            _buildItemCode(getCodeFromIndex(otpCode, 3)),
                            _buildItemCode(getCodeFromIndex(otpCode, 4)),
                            _buildItemCode(getCodeFromIndex(otpCode, 5))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: ButtonWidget(
                            margin: EdgeInsets.symmetric(
                                horizontal: UIHelper.size20),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: UIHelper.size50,
                                  height: 40,
                                ),
                                Expanded(
                                  child: Text(
                                    model.isExpired ? 'GỬI LẠI MÃ' : 'XÁC THỰC',
                                    style: textStyleButton(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: UIHelper.size50,
                                  height: 50,
                                  child: CountDownTimer(
                                    secondsRemaining: 60,
                                    whenTimeExpires: () =>
                                        model.setExpired(true),
                                    countDownTimerStyle: textStyleRegularBody(
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              if (model.isExpired) {
                                model.setExpired(false);
                              } else {
                                model.verifyOtp(verifyArgument.verificationId);
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 210 + UIHelper.paddingBottom,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          childAspectRatio: 2.5,
                          mainAxisSpacing: UIHelper.size5,
                          crossAxisSpacing: UIHelper.size5,
                          padding: EdgeInsets.only(
                              left: UIHelper.size10, right: UIHelper.size10),
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            _buildItemNumber('1',
                                onTap: () => model.setCode('1')),
                            _buildItemNumber('2',
                                onTap: () => model.setCode('2')),
                            _buildItemNumber('3',
                                onTap: () => model.setCode('3')),
                            _buildItemNumber('4',
                                onTap: () => model.setCode('4')),
                            _buildItemNumber('5',
                                onTap: () => model.setCode('5')),
                            _buildItemNumber('6',
                                onTap: () => model.setCode('6')),
                            _buildItemNumber('7',
                                onTap: () => model.setCode('7')),
                            _buildItemNumber('8',
                                onTap: () => model.setCode('8')),
                            _buildItemNumber('9',
                                onTap: () => model.setCode('9')),
                            SizedBox(),
                            _buildItemNumber('0',
                                onTap: () => model.setCode('0')),
                            ButtonWidget(
                              onTap: () => model.deleteCode(),
                              backgroundColor: Colors.white,
                              elevation: 2,
                              child: Image.asset(
                                Images.DELETE,
                                scale: 0.5,
                                width: UIHelper.size25,
                                height: UIHelper.size25,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
