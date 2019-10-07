import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/clipper_right_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui-helper.dart';

import 'clipper_left_widget.dart';

class CompareTeamWidget extends StatelessWidget {
  final Team _team1;
  final Team _team2;

  CompareTeamWidget({@required Team team1, @required Team team2})
      : _team1 = team1,
        _team2 = team2;

  Widget _buildLogoBackground() => Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: UIHelper.size(150),
              width: UIHelper.screenWidth / 2 - 10,
              child: ClipPath(
                clipper: ClipperLeftWidget(),
                child: Container(
                  color: parseColor(_team1.dress),
                  child: Center(
                    child: ImageWidget(
                      source: _team1.logo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size(80),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: UIHelper.size(150),
              width: UIHelper.screenWidth / 2 - 10,
              child: ClipPath(
                clipper: ClipperRightWidget(),
                child: Container(
                  color: parseColor(_team2.dress),
                  child: Center(
                    child: ImageWidget(
                      source: _team2.logo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size(80),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: UIHelper.size(150),
            child: Align(
              child: Image.asset(
                Images.FIND_MATCH,
                width: UIHelper.size40,
                height: UIHelper.size40,
                color: Colors.red,
              ),
            ),
          )
        ],
      );

  Widget _buildItemCompare(String title, String left, String right) => Padding(
        padding: EdgeInsets.symmetric(
            vertical: UIHelper.size10, horizontal: UIHelper.size15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Text(left,
                    textAlign: TextAlign.left, style: textStyleRegular())),
            Text(title, style: textStyleRegularTitle()),
            Expanded(
                child: Text(right,
                    textAlign: TextAlign.right, style: textStyleRegular())),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildLogoBackground(),
        UIHelper.verticalSpaceMedium,
        UIHelper.verticalSpaceMedium,
        _buildItemCompare('Điểm', '10000000', '1100'),
        _buildItemCompare('Xếp hạng', '100', '102'),
        _buildItemCompare('Đối đầu', '1', '3'),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: UIHelper.size10, horizontal: UIHelper.size15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlutterRatingBarIndicator(
                rating: 2.5,
                itemCount: 5,
                itemPadding: EdgeInsets.only(left: 2),
                itemSize: UIHelper.size(15),
                emptyColor: Colors.amber.withAlpha(90),
              ),
              Text(
                'Đánh giá',
                style: textStyleRegularTitle(),
              ),
              FlutterRatingBarIndicator(
                rating: 2.5,
                itemCount: 5,
                itemPadding: EdgeInsets.only(left: 2),
                itemSize: UIHelper.size(15),
                emptyColor: Colors.amber.withAlpha(90),
              ),
            ],
          ),
        ),
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(UIHelper.size15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Xem thêm đánh giá ${_team2.name}',
                  style: textStyleRegularTitle(),
                ),
                Image.asset(
                  Images.NEXT,
                  width: UIHelper.size15,
                  height: UIHelper.size15,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
        LineWidget(),
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(UIHelper.size15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Chọn sân thi đấu (10 sân gợi ý)',
                  style: textStyleRegularTitle(),
                ),
                Image.asset(
                  Images.NEXT,
                  width: UIHelper.size15,
                  height: UIHelper.size15,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
