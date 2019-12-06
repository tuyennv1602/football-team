import 'package:flutter/material.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/ui/widget/custom_expansion_panel.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';

typedef void OnSelectedType(int type);

class ChooseRatioTypeWidget extends StatefulWidget {
  final OnSelectedType onSelectedType;
  final Color primaryColor;

  ChooseRatioTypeWidget(
      {@required this.onSelectedType, this.primaryColor = Colors.black});

  @override
  State<StatefulWidget> createState() => _ChooseRatioTypeState();
}

class _ChooseRatioTypeState extends State<ChooseRatioTypeWidget> {
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
            StringUtil.getRatioName(type),
            style: textStyleRegular(color: widget.primaryColor),
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
      focusedColor: widget.primaryColor,
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (c, isExpanded) {
            return Row(
              children: <Widget>[
                Text(
                  'Tỉ lệ kèo (thắng - thua)',
                  style: textStyleRegular(color: widget.primaryColor),
                ),
                Expanded(
                  child: Text(
                    StringUtil.getRatioName(_selectedType),
                    textAlign: TextAlign.right,
                    style: textStyleSemiBold(color: widget.primaryColor),
                  ),
                ),
                UIHelper.horizontalSpaceMedium
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
                  _buildItemType(Constants.RATIO_50_50),
                  _buildItemType(Constants.RATIO_40_60),
                  _buildItemType(Constants.RATIO_30_70),
                  _buildItemType(Constants.RATIO_20_80),
                  _buildItemType(Constants.RATIO_0_100),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
