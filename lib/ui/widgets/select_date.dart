import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/res/styles.dart';

typedef void OnSelectedDate(DateTime dateTime);

class SelectDateWidget extends StatefulWidget {
  final EdgeInsets padding;
  final TextStyle textStyle;
  final String formatDate;
  final OnSelectedDate onSelectedDate;

  const SelectDateWidget(
      {Key key,
      this.padding,
      this.textStyle,
      this.formatDate,
      this.onSelectedDate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectDateState();
  }
}

class _SelectDateState extends State<SelectDateWidget> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  _showDatePicker(BuildContext context, Function onSelected) async {
    var _now = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(_now.year, _now.month, _now.day),
        lastDate: _now.add(Duration(days: 365)));
    if (picked != null && picked != _selectedDate) {
      onSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDatePicker(context, (date) {
        setState(
          () {
            _selectedDate = date;
          },
        );
        if (widget.onSelectedDate != null) {
          widget.onSelectedDate(date);
        }
      }),
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Text(
          DateFormat(widget.formatDate ?? 'dd/MM/yyyy').format(_selectedDate),
          style: widget.textStyle ?? textStyleSemiBold(),
        ),
      ),
    );
  }
}
