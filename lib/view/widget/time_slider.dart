import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/widget/button_widget.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/ui_helper.dart';

typedef void OnSelectedTime(double start, double end, String dayOfWeeks);

final List<String> _kDayOfWeeks = ['1', '2', '3', '4', '5', '6', '7'];

class TimeSliderWidget extends StatefulWidget {
  final OnSelectedTime onSelectedTime;

  const TimeSliderWidget({Key key, @required this.onSelectedTime})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TimeSliderState();
  }
}

class TimeSliderState extends State<TimeSliderWidget> {
  RangeValues _values = RangeValues(4, 24);
  List<String> _selectedDay = [];

  @override
  Widget build(BuildContext context) {
    var formattedStart = DateUtil.getTimeStringFromDouble(_values.start);
    var formattedEnd = DateUtil.getTimeStringFromDouble(_values.end);
    List<Widget> _children = [];
    _kDayOfWeeks.asMap().forEach(
      (index, title) {
        _children.add(
          ChoiceChip(
            pressElevation: 0,
            selectedColor: PRIMARY,
            backgroundColor: Colors.grey,
            label: Text(DateUtil.getDayOfWeek(int.parse(title)),
                style: textStyleRegular(color: Colors.white)),
            selected: _selectedDay.contains(title),
            onSelected: (isSelected) {
              if (isSelected) {
                this.setState(() {
                  _selectedDay.add(title);
                });
              } else {
                this.setState(() {
                  _selectedDay.remove(title);
                });
              }
            },
          ),
        );
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: UIHelper.size20,
              left: UIHelper.size15,
              right: UIHelper.size15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Thời gian có thể chơi',
                style: textStyleMediumTitle(),
              ),
              Text(
                '$formattedStart - $formattedEnd',
                style: textStyleSemiBold(),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: UIHelper.size20, bottom: UIHelper.size10),
          child: SliderTheme(
            data: SliderThemeData(
                trackHeight: UIHelper.size5,
                valueIndicatorTextStyle: textStyleSemiBold(color: Colors.white)),
            child: RangeSlider(
              max: 24,
              min: 0,
              divisions: 48,
              labels: RangeLabels('$formattedStart', '$formattedEnd'),
              activeColor: PRIMARY,
              values: _values,
              onChanged: (values) {
                this.setState(
                  () {
                    if (values.end - values.start >= 1.5) {
                      _values = RangeValues(values.start, values.end);
                    } else {
                      if (_values.start == values.start) {
                        _values = RangeValues(_values.start, _values.start + 1.5);
                      } else {
                        _values = RangeValues(_values.end - 1.5, _values.end);
                      }
                    }
                  },
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.size15, vertical: UIHelper.size10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Ngày có thể chơi',
                style: textStyleMediumTitle(),
              ),
              InkWell(
                onTap: () {
                  _selectedDay.clear();
                  setState(() {
                    _selectedDay.addAll(_kDayOfWeeks);
                  });
                },
                child: Text(
                  'Chọn tất cả',
                  style: textStyleSemiBold(),
                ),
              )
            ],
          ),
        ),
        Align(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: UIHelper.size5,
            children: _children,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size20),
          child: ButtonWidget(
              child: Text(
                'THÊM',
                style: textStyleButton(),
              ),
              margin: EdgeInsets.all(UIHelper.size15),
              onTap: () {
                if (_selectedDay.length == 0) {
                  UIHelper.showSimpleDialog('Vui lòng chọn ngày có thể chơi');
                } else {
                  widget.onSelectedTime(
                      _values.start, _values.end, _selectedDay.join(','));
                }
              }),
        ),
      ],
    );
  }
}
