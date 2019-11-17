import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
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
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.size10),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
        child: InkWell(
          onTap: () => _showAuthenticationBottomSheet(context),
          child: Padding(
            padding: EdgeInsets.all(UIHelper.size10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: textStyleSemiBold(),
                ),
                Text(
                  content,
                  style: textStyleRegular(),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Số tiền: ',
                      style: textStyleRegular(),
                    ),
                    Text(
                      StringUtil.formatCurrency(price),
                      style: textStyleSemiBold(),
                    ),
                    Expanded(
                      child: Text(
                        status % 2 == 0 ? 'Đã đóng' : 'Chưa đóng',
                        textAlign: TextAlign.right,
                        style: textStyleRegularBody(
                            color: status % 2 == 0 ? Colors.green : Colors.grey),
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
    UIHelper().init(context);
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
              onTap: () => NavigationService.instance().goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
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
