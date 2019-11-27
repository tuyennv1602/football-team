import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/authentication_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';

class TeamFundPage extends StatelessWidget {
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

  Widget _buildItemFund(BuildContext context, String title, String content,
          double price, int status) =>
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.size15),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.size15),
        child: InkWell(
          onTap: () => _showAuthenticationBottomSheet(context),
          child: Padding(
            padding: EdgeInsets.all(UIHelper.size15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: UIHelper.size5),
                  child: Text(
                    title,
                    style: textStyleSemiBold(),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Số tiền: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: REGULAR,
                            fontSize: UIHelper.size(17)),
                      ),
                      TextSpan(
                        text: StringUtil.formatCurrency(100000),
                        style: TextStyle(
                            fontFamily: SEMI_BOLD,
                            color: Colors.black,
                            fontSize: UIHelper.size(17)),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Hạn đóng: ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: REGULAR,
                                fontSize: UIHelper.size(17)),
                          ),
                          TextSpan(
                            text: '15/09/2019',
                            style: TextStyle(
                                fontFamily: SEMI_BOLD,
                                color: Colors.black,
                                fontSize: UIHelper.size(17)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        status % 2 == 0 ? 'Đã đóng' : 'Chưa đóng',
                        textAlign: TextAlign.right,
                        style: textStyleRegularBody(
                            color:
                                status % 2 == 0 ? Colors.green : Colors.grey),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Đóng quỹ đội bóng',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: UIHelper.size15),
                children: <Widget>[
                  _buildItemFund(context, 'Đóng quỹ tháng 10/2019',
                      'Vui lòng hoàn thành trước 15/10', 100000, 1),
                  UIHelper.verticalIndicator,
                  _buildItemFund(context, 'Đóng quỹ tháng 09/2019',
                      'Vui lòng hoàn thành trước 15/09', 100000, 2),
                  UIHelper.verticalIndicator,
                  _buildItemFund(context, 'Đóng quỹ tháng 08/2019',
                      'Vui lòng hoàn thành trước 15/08', 100000, 2)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
