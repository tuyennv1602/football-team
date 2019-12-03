import 'package:flutter/material.dart';
import 'package:myfootball/model/transaction.dart';
import 'package:myfootball/resource/fonts.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class ItemTransactionWidget extends StatelessWidget {
  final Transaction transaction;

  ItemTransactionWidget({Key key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
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
                    Text(
                      transaction.content,
                      style: textStyleSemiBold(),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Số tiền GD: ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: REGULAR,
                                fontSize: UIHelper.size(14)),
                          ),
                          TextSpan(
                            text: transaction.getPrice,
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
                                text: 'Ngày GD: ',
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
                        Expanded(
                          child: Text(
                            'Thành công',
                            textAlign: TextAlign.right,
                            style: textStyleRegularBody(color: Colors.green),
                          ),
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
