import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/stringres.dart';
import 'package:myfootball/resource/styles.dart';
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
        _children.add(
          Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: FilterChip(
              pressElevation: 0,
              selectedColor: getPositionColor(title),
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
