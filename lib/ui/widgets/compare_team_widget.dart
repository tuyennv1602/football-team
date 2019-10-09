import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/clipper_right_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui_helper.dart';

import 'clipper_left_widget.dart';

class CompareTeamWidget extends StatelessWidget {
  final Team _team1;
  final Team _team2;

  CompareTeamWidget({@required Team team1, @required Team team2})
      : _team1 = team1,
        _team2 = team2;

  Widget _buildLogoBackground(BuildContext context) => Container(
        height: UIHelper.size(180),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Images.GROUND), fit: BoxFit.cover),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ImageWidget(
                    source: _team1.logo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size(80),
                  ),
                  SizedBox(
                    height: UIHelper.size(50),
                    child: Text(
                      _team1.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: textStyleSemiBold(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Image.asset(
              Images.FIND_MATCH,
              width: UIHelper.size50,
              height: UIHelper.size50,
              color: Colors.white,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ImageWidget(
                    source: _team2.logo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size(80),
                  ),
                  SizedBox(
                    height: UIHelper.size(50),
                    child: Text(
                      _team2.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: textStyleSemiBold(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildTeamDress() => Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: UIHelper.size10,
              width: UIHelper.screenWidth / 2 + 4,
              child: ClipPath(
                clipper: ClipperLeftWidget(),
                child: Container(
                  color: parseColor(_team1.dress),
                  child: SizedBox(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: UIHelper.size10,
              width: UIHelper.screenWidth / 2 + 4,
              child: ClipPath(
                clipper: ClipperRightWidget(),
                child: Container(
                  color: parseColor(_team2.dress),
                  child: SizedBox(),
                ),
              ),
            ),
          ),
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
        _buildLogoBackground(context),
        _buildTeamDress(),
        LineWidget(),
        UIHelper.verticalSpaceMedium,
        _buildItemCompare('Điểm', '10000000', '1100'),
        _buildItemCompare('Xếp hạng', '100', '102'),
        _buildItemCompare('Đối đầu', '1', '3'),
        Padding(
          padding: EdgeInsets.only(
              bottom: UIHelper.size5,
              top: UIHelper.size10,
              left: UIHelper.size15,
              right: UIHelper.size15),
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
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: UIHelper.size10, horizontal: UIHelper.size15),
              child: Text(
                'Xem thêm đánh giá',
                style: textStyleItalic(size: 14, color: PRIMARY),
              ),
            ),
          ),
        ),
        _buildItemCompare('Sân nhà', 'Có', 'Không'),
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
