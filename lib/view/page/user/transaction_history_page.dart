import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/item_transaction.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/user_transaction_viewmodel.dart';
import 'package:provider/provider.dart';

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
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<UserTransactionViewModel>(
                model: UserTransactionViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.getTransactions(0),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.transactions.length == 0
                        ? EmptyWidget(message: 'Không có giao dịch')
                        : ListView.separated(
                            itemCount: model.transactions.length,
                            padding: EdgeInsets.symmetric(
                                vertical: UIHelper.padding),
                            physics: BouncingScrollPhysics(),
                            separatorBuilder: (c, index) =>
                                UIHelper.verticalIndicator,
                            itemBuilder: (c, index) => ItemTransactionWidget(
                              transaction: model.transactions[index],
                              showCreator: false,
                            ),
                          ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
