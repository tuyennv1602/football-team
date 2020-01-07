import 'package:flutter/material.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/widget/customize_expansion_panel.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/view/ui_helper.dart';

typedef void OnSelectedType(int type);

class ChooseDayOfWeek extends StatefulWidget {
  final OnSelectedType onSelectedType;
  final Color primaryColor;

  ChooseDayOfWeek(
      {@required this.onSelectedType, this.primaryColor = Colors.black});

  @override
  State<StatefulWidget> createState() => _ChooseRatioTypeState();
}

class _ChooseRatioTypeState extends State<ChooseDayOfWeek> {
  bool _isExpanded = false;
  int _selectedType = 1;

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
            DateUtil.getDayOfWeek(type),
            style: textStyleRegular(color: widget.primaryColor),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomizeExpansionPanelList(
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
                  'Chọn ngày đá',
                  style: textStyleMediumTitle(color: widget.primaryColor),
                ),
                Expanded(
                  child: Text(
                    DateUtil.getDayOfWeek(_selectedType),
                    textAlign: TextAlign.right,
                    style: textStyleSemiBold(color: widget.primaryColor),
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
                  _buildItemType(1),
                  _buildItemType(2),
                  _buildItemType(3),
                  _buildItemType(4),
                  _buildItemType(5),
                  _buildItemType(6),
                  _buildItemType(7),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
