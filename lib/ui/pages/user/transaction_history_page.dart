import 'package:flutter/material.dart';
import 'package:myfootball/models/transaction.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/item_transaction.dart';
import 'package:myfootball/utils/ui_helper.dart';

class TransactionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Lịch sử giao dịch',
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
              child: ListView.separated(
                itemCount: 2,
                padding: EdgeInsets.symmetric(vertical: UIHelper.size15),
                separatorBuilder: (c, index) => UIHelper.verticalIndicator,
                itemBuilder: (c, index) => ItemTransactionWidget(
                  transaction: Transaction(
                      content: 'Đóng quỹ Acazia FC',
                      price: 100000,
                      type: index),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
