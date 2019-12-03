import 'package:flutter/material.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/ui/widget/custom_expansion_panel.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';

typedef void OnSelectedType(int type);

class ChooseTransactionTypeWidget extends StatefulWidget {
  final OnSelectedType onSelectedType;

  ChooseTransactionTypeWidget({@required this.onSelectedType});

  @override
  State<StatefulWidget> createState() => _ChooseTransactionTypeState();
}

class _ChooseTransactionTypeState extends State<ChooseTransactionTypeWidget> {
  bool _isExpanded = false;
  int _selectedType = Constants.RATIO_50_50;

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
                UIHelper.horizontalSpaceMedium
              ],
            );
          },
          isExpanded: _isExpanded,
          body: Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildItemType(Constants.TRANSACTION_IN),
                _buildItemType(Constants.TRANSACTION_OUT),
                UIHelper.verticalSpaceMedium
              ],
            ),
          ),
        )
      ],
    );
  }
}
