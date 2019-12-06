import 'package:flutter/material.dart';
import 'package:myfootball/model/transaction.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class ItemTransactionWidget extends StatelessWidget {
  final Transaction transaction;
  final bool showCreator;

  ItemTransactionWidget({Key key, this.transaction, this.showCreator = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.padding),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
      child: Padding(
        padding: EdgeInsets.all(UIHelper.padding),
        child: Row(
          children: <Widget>[
            Container(
              height: UIHelper.size50,
              width: UIHelper.size50,
              padding: EdgeInsets.all(UIHelper.size10),
              decoration: BoxDecoration(
                color: transaction.getType == TRANSACTION_TYPE.OUT
                    ? Colors.red
                    : Colors.green,
                borderRadius: BorderRadius.circular(UIHelper.size25),
              ),
              child: Image.asset(
                transaction.getType == TRANSACTION_TYPE.OUT
                    ? Images.WALLET_OUT
                    : Images.WALLET_IN,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: UIHelper.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        transaction.title,
                        style: textStyleMediumTitle(),
                      ),
                    ),
                    Text(
                      'Số tiền: ${transaction.getPrice}',
                      style: textStyleMedium(),
                    ),
                    Row(
                      children: <Widget>[
                        showCreator
                            ? Expanded(
                                child: Text(
                                  'bởi: ${transaction.userName}',
                                  style: textStyleRegular(color: Colors.grey),
                                ),
                              )
                            : SizedBox(),
                        Text(
                          transaction.getCreateTime,
                          style: textStyleRegular(color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
