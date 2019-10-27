import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/item_option.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:provider/provider.dart';

class FinancePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    var wallet = Provider.of<Team>(context).wallet;
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: UIHelper.size(110) + UIHelper.paddingTop,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(
                bottom: UIHelper.size30,
                left: UIHelper.size15,
                right: UIHelper.size15),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/wallet_bg.jpg'),
                    fit: BoxFit.cover)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Tổng',
                  style: textStyleTitle(),
                ),
                Text(
                  StringUtil.formatCurrency(wallet),
                  style: textStyleTitle(),
                )
              ],
            ),
          ),
          AppBarWidget(
            centerContent: Text(
              '',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
          ),
          Container(
            margin:
                EdgeInsets.only(top: UIHelper.size(90) + UIHelper.paddingTop),
            child: BorderBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ItemOptionWidget(
                    Images.FUND_NOTIFY,
                    'Thông báo đóng quỹ',
                    iconColor: Colors.red,
                  ),
                  LineWidget(),
                  ItemOptionWidget(
                    Images.BUDGET,
                    'Danh sách đóng quỹ',
                    iconColor: Colors.amber,
                  ),
                  LineWidget(),
                  Padding(
                    padding: EdgeInsets.all(UIHelper.size15),
                    child: Text(
                      'Tất cả giao dịch',
                      style: textStyleSemiBold(),
                    ),
                  ),
                  Expanded(
                    child: Center(
                        child: EmptyWidget(message: 'Không có giao dịch nào')),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
