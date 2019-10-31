import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

import 'clipper_left_widget.dart';
import 'clipper_right_widget.dart';

class CompareTeamWidget extends StatelessWidget {
  final Team team1;
  final Team team2;

  const CompareTeamWidget({Key key, @required this.team1, @required this.team2})
      : super(key: key);

  Widget _buildItemCompare(String title, String left, String right) => Padding(
        padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Text(left,
                    textAlign: TextAlign.left, style: textStyleRegularTitle())),
            Text(title, style: textStyleRegular()),
            Expanded(
                child: Text(right,
                    textAlign: TextAlign.right,
                    style: textStyleRegularTitle())),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildItemCompare('Điểm', '${team1.point}', '${team2.point}'),
        _buildItemCompare('Xếp hạng', '${team1.rank}', '${team2.rank}'),
        Padding(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlutterRatingBarIndicator(
                rating: 2.5,
                itemCount: 5,
                itemPadding: EdgeInsets.only(left: 2),
                itemSize: UIHelper.size(12),
                emptyColor: Colors.amber.withAlpha(90),
              ),
              Text(
                'Đánh giá',
                style: textStyleRegular(),
              ),
              FlutterRatingBarIndicator(
                rating: 2.5,
                itemCount: 5,
                itemPadding: EdgeInsets.only(left: 2),
                itemSize: UIHelper.size(12),
                emptyColor: Colors.amber.withAlpha(90),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: UIHelper.size10,
                width: 100,
                child: ClipPath(
                  clipper: ClipperLeftWidget(),
                  child: Container(
                    color: parseColor(team1.dress),
                    child: SizedBox(),
                  ),
                ),
              ),
              Text(
                'Màu áo',
                style: textStyleRegular(),
              ),
              Container(
                height: UIHelper.size10,
                width: 100,
                child: ClipPath(
                  clipper: ClipperRightWidget(),
                  child: Container(
                    color: parseColor(team2.dress),
                    child: SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
