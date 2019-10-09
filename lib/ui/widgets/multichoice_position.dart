import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

typedef void OnChangePositions(List<String> positions);

class MultiChoicePosition extends StatefulWidget {
  final OnChangePositions onChangePositions;
  final List<String> initPositions;

  MultiChoicePosition(
      {@required OnChangePositions onChangePositions,
      List<String> initPositions})
      : this.onChangePositions = onChangePositions,
        this.initPositions = initPositions;

  @override
  _MultiChoicePositionState createState() => _MultiChoicePositionState();
}

class _MultiChoicePositionState extends State<MultiChoicePosition> {
  List<String> _selectedPositions;

  @override
  Widget build(BuildContext context) {
    _selectedPositions = widget.initPositions;
    List<Widget> _children = [];
    StringRes.POSITIONS_SYMBOL.asMap().forEach(
      (index, title) {
        Color _selectedColor;
        switch (index) {
          case 0:
            _selectedColor = GK;
            break;
          case 1:
            _selectedColor = DF;
            break;
          case 2:
            _selectedColor = MF;
            break;
          case 3:
            _selectedColor = FW;
            break;
        }
        _children.add(
          Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: FilterChip(
              pressElevation: 0,
              selectedColor: _selectedColor,
              backgroundColor: Colors.grey,
              label: Text(title, style: textStyleRegular(color: Colors.white)),
              selected: _selectedPositions.contains(title),
              onSelected: (isSelected) {
                if (isSelected) {
                  this.setState(() {
                    _selectedPositions.add(title);
                  });
                } else {
                  this.setState(() {
                    _selectedPositions.remove(title);
                  });
                }
                widget.onChangePositions(_selectedPositions);
              },
            ),
          ),
        );
      },
    );
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: UIHelper.size5,
      children: _children,
    );
  }
}
