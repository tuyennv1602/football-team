import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/authentication_widget.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/button_widget.dart';
import 'package:myfootball/view/widget/input_price_widget.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/utils/ui_helper.dart';

class InputMoneyPage extends StatelessWidget {
  _showAuthenticationBottomSheet(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (c) => AuthenticationWidget(
          onAuthentication: (isSuccess) {
            if (isSuccess) {
              Navigator.of(context).pop();
            }
          },
        ),
      );

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
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: UIHelper.size10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: textStyleMediumTitle(),
                    ),
                    Text(
                      'Miễn phí',
                      style: textStyleRegularBody(color: Colors.grey),
                    )
                  ],
                ),
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
    return Scaffold(
      backgroundColor: PRIMARY,
      resizeToAvoidBottomPadding: false,
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
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: UIHelper.size10),
                                  child: InputPriceWidget(
                                    onChangedText: (text) {},
                                    textStyle: textStyleSemiBold(size: 22),
                                    hintTextStyle: textStyleMediumTitle(
                                        size: 22, color: Colors.grey),
                                    hint: '0đ',
                                  ),
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
                            style: textStyleSemiBold(color: PRIMARY),
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
                      onTap: () => _showAuthenticationBottomSheet(context)),
                  UIHelper.homeButtonSpace
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
