import 'package:flutter/material.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/widget/custom_expansion_panel.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/view/ui_helper.dart';

typedef void OnSelectedType(int type);

class ChooseTransactionWidget extends StatefulWidget {
  final OnSelectedType onSelectedType;

  ChooseTransactionWidget({@required this.onSelectedType});

  @override
  State<StatefulWidget> createState() => _ChooseTransactionTypeState();
}

class _ChooseTransactionTypeState extends State<ChooseTransactionWidget> {
  bool _isExpanded = false;
  int _selectedType = Constants.TRANSACTION_OUT;

  @override
  void initState() {
    super.initState();
    widget.onSelectedType(_selectedType);
  }

  Widget _buildItemType(int type) => InkWell(
        onTap: () {
          setState(() {
            _isExpanded = false;
            _selectedType = type;
          });
          widget.onSelectedType(type);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.size50, vertical: UIHelper.size(7)),
          child: Text(
            StringUtil.getTransactionName(type),
            style: textStyleRegular(color: Colors.white),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          _isExpanded = !isExpanded;
        });
      },
      focusedColor: Colors.white,
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (c, isExpanded) {
            return Row(
              children: <Widget>[
                Text(
                  'Loại giao dịch',
                  style: textStyleRegularBody(color: Colors.white),
                ),
                Expanded(
                  child: Text(
                    StringUtil.getTransactionName(_selectedType),
                    textAlign: TextAlign.right,
                    style: textStyleSemiBold(color: Colors.white, size: 18),
                  ),
                ),
                SizedBox(width: UIHelper.size10, height: 5),
              ],
            );
          },
          isExpanded: _isExpanded,
          body: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: UIHelper.size10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _buildItemType(Constants.TRANSACTION_OUT),
                  _buildItemType(Constants.TRANSACTION_IN),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
