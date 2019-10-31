import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final TextStyle textStyle;

  ExpandableTextWidget(this.text, {this.textStyle});

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableTextWidget>
    with TickerProviderStateMixin<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 200),
      child: LayoutBuilder(builder: (c, size) {
        final span = TextSpan(
            text: widget.text, style: widget.textStyle ?? textStyleRegular());
        final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: size.maxWidth);
        TextSelection selection =
            TextSelection(baseOffset: 0, extentOffset: widget.text.length);
        List<TextBox> boxes = tp.getBoxesForSelection(selection);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.text,
                softWrap: true,
                maxLines: isExpanded ? 1000 : 2,
                overflow: TextOverflow.fade,
                style: widget.textStyle ?? textStyleRegularTitle()),
            boxes.length > 2
                ? InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(isExpanded ? "Thu gọn" : "Xem thêm",
                            style: textStyleItalic(size: 14, color: PRIMARY)),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        );
      }),
    );
  }
}
