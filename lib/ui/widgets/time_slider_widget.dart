import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/ui_helper.dart';

typedef void OnSelectedTime(double start, double end);

class TimeSliderWidget extends StatefulWidget {
  final OnSelectedTime onSelectedTime;

  TimeSliderWidget({@required OnSelectedTime onSelectedTime})
      : this.onSelectedTime = onSelectedTime;

  @override
  State<StatefulWidget> createState() {
    return TimeSliderState();
  }
}

class TimeSliderState extends State<TimeSliderWidget> {
  RangeValues _values = RangeValues(0, 24);

  @override
  Widget build(BuildContext context) {
    var formattedStart = DateUtil().getTimeStringFromDouble(_values.start);
    var formattedEnd = DateUtil().getTimeStringFromDouble(_values.end);
    return Column(
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
                style: textStyleRegularTitle(),
              ),
              Text(
                '$formattedStart - $formattedEnd',
                style: textStyleSemiBold(),
              )
            ],
          ),
        ),
        UIHelper.verticalSpaceLarge,
        SliderTheme(
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
        UIHelper.verticalSpaceLarge,
        ButtonWidget(
            child: Text(
              'THÊM',
              style: textStyleButton(),
            ),
            margin: EdgeInsets.all(UIHelper.size15),
            onTap: () => widget.onSelectedTime(_values.start, _values.end)),
        UIHelper.verticalSpaceLarge,
      ],
    );
  }
}
