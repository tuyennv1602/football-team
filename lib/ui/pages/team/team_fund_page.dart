import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';

class TeamFundPage extends StatelessWidget {
  Widget _buildItemFund(BuildContext context, String title, String content,
          double price, int status) =>
      Opacity(
        opacity: status % 2 == 0 ? 0.5 : 1,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIHelper.size15),
          ),
          margin: EdgeInsets.symmetric(horizontal: UIHelper.size15),
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
                            color: status % 2 == 0 ? Colors.green : Colors.red),
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
              onTap: () => Navigator.of(context).pop(),
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
