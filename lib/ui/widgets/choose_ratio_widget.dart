import 'package:flutter/material.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/custom_expansion_panel.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';

typedef void OnSelectedType(int type);

class ChooseRatioTypeWidget extends StatefulWidget {
  final OnSelectedType onSelectedType;

  ChooseRatioTypeWidget({@required this.onSelectedType});

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
            style: textStyleRegular(),
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
      children: <ExpansionPanel>[
        ExpansionPanel(
            headerBuilder: (c, isExpanded) {
              return Row(
                children: <Widget>[
                  Text(
                    'Tỉ lệ kèo (Thắng - Thua)',
                    style: textStyleRegularTitle(),
                  ),
                  Expanded(
                    child: Text(
                      StringUtil.getRatioName(_selectedType),
                      textAlign: TextAlign.right,
                      style: textStyleSemiBold(),
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
                  _buildItemType(Constants.RATIO_50_50),
                  _buildItemType(Constants.RATIO_40_60),
                  _buildItemType(Constants.RATIO_30_70),
                  _buildItemType(Constants.RATIO_20_80),
                  _buildItemType(Constants.RATIO_0_100),
                  UIHelper.verticalSpaceMedium
                ],
              ),
            ))
      ],
    );
  }
}
