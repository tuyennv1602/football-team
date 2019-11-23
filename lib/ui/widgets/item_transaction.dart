import 'package:flutter/material.dart';
import 'package:myfootball/models/transaction.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';

class ItemTransactionWidget extends StatelessWidget {
  final Transaction transaction;

  ItemTransactionWidget({Key key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.size10),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
      child: Padding(
        padding: EdgeInsets.all(UIHelper.size10),
        child: Row(
          children: <Widget>[
            Image.asset(
              transaction.getType == TRANSACTION_TYPE.OUT
                  ? Images.WALLET_OUT
                  : Images.WALLET_IN,
              width: UIHelper.size30,
              height: UIHelper.size30,
              color: transaction.getType == TRANSACTION_TYPE.OUT
                  ? Colors.red
                  : Colors.green,
            ),
            UIHelper.horizontalSpaceMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    transaction.content,
                    style: textStyleSemiBold(),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Số tiền giao dịch: ',
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily: REGULAR,
                              fontSize: UIHelper.size(14)),
                        ),
                        TextSpan(
                          text: StringUtil.formatCurrency(transaction.price),
                          style: TextStyle(
                              fontFamily: SEMI_BOLD,
                              color: Colors.black,
                              fontSize: UIHelper.size(15)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Ngày giao dịch: ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: REGULAR,
                                  fontSize: UIHelper.size(14)),
                            ),
                            TextSpan(
                              text: transaction.getCreateTime,
                              style: TextStyle(
                                  fontFamily: SEMI_BOLD,
                                  color: Colors.black,
                                  fontSize: UIHelper.size(15)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Thành công',
                        style: textStyleRegularBody(color: Colors.green),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
