import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/input_price_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class InputMoneyPage extends StatelessWidget {
  Future<void> _authentication(BuildContext context) async {
    var _localAuth = LocalAuthentication();
    var _canCheck = await _localAuth.canCheckBiometrics;
    try {
      if (_canCheck) {
        bool didAuthenticate = await _localAuth.authenticateWithBiometrics(
            stickyAuth: true,
            localizedReason: 'Vui lòng xác thực để thực hiện giao dịch',
          androidAuthStrings: AndroidAuthMessages(
            signInTitle: 'Xác thực',
            cancelButton: 'Huỷ',
            fingerprintHint: 'Đặt tay vào cảm biến',
            fingerprintSuccess: 'Xác thực thành công',
            fingerprintNotRecognized: 'Không khớp',
          ),
          iOSAuthStrings: IOSAuthMessages(
            cancelButton: 'Huỷ',
            goToSettingsButton: 'Cài đặt'
          )
        );
        print(didAuthenticate);
      }else{
        UIHelper.showSimpleDialog('Không thể xác thực');
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
      }
    }
  }

  Widget _buildItemResource(
          BuildContext context, String iconRes, String name) =>
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: UIHelper.size15, vertical: UIHelper.size10),
        child: Row(
          children: <Widget>[
            Image.asset(
              iconRes,
              width: UIHelper.size45,
              height: UIHelper.size45,
            ),
            UIHelper.horizontalSpaceMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: textStyleRegularTitle(),
                  ),
                  Text(
                    'Miễn phí',
                    style: textStyleRegularBody(color: Colors.grey),
                  )
                ],
              ),
            ),
            Image.asset(
              Images.NEXT,
              width: UIHelper.size10,
              height: UIHelper.size10,
              color: LINE_COLOR,
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Nạp tiền vào ví',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(UIHelper.size15),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Số tiền:',
                                style: textStyleSemiBold(size: 22),
                              ),
                              UIHelper.horizontalSpaceMedium,
                              Expanded(
                                child: InputPriceWidget(
                                  onChangedText: (text) {},
                                  textStyle: textStyleSemiBold(size: 22),
                                  hintTextStyle:
                                      textStyleRegularTitle(size: 22),
                                ),
                              ),
                            ],
                          ),
                        ),
                        LineWidget(),
                        Padding(
                          padding: EdgeInsets.all(UIHelper.size15),
                          child: Text(
                            'Chọn nguồn tiền',
                            style: textStyleRegularTitle(color: PRIMARY),
                          ),
                        ),
                        _buildItemResource(context, 'assets/images/ic_momo.png',
                            'Ví điện tử MoMo'),
                        LineWidget(),
                        _buildItemResource(context,
                            'assets/images/ic_zalo_pay.png', 'Zalo pay'),
                        LineWidget(),
                        _buildItemResource(context,
                            'assets/images/ic_viettel_pay.png', 'Viettel pay'),
                        LineWidget(),
                        _buildItemResource(
                            context,
                            'assets/images/ic_bank_card.png',
                            'Ngân hàng liên kết'),
                      ],
                    ),
                  ),
                  ButtonWidget(
                      child: Text(
                        'NẠP TIỀN',
                        style: textStyleButton(),
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: UIHelper.size15,
                          vertical: UIHelper.size10),
                      onTap: () => _authentication(context))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
