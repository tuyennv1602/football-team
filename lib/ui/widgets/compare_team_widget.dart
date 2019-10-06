import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui-helper.dart';

class CompareTeamWidget extends StatelessWidget {
  final Team _team1;
  final Team _team2;

  CompareTeamWidget({@required Team team1, @required Team team2})
      : _team1 = team1,
        _team2 = team2;

  Widget _buildItemCompare(String title, String left, String right) => Padding(
        padding: EdgeInsets.symmetric(
            vertical: UIHelper.size10, horizontal: UIHelper.size15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Text(left,
                    textAlign: TextAlign.left, style: textStyleRegularTitle())),
            Text(title, style: textStyleSemiBold()),
            Expanded(
                child: Text(right,
                    textAlign: TextAlign.right,
                    style: textStyleRegularTitle())),
          ],
        ),
      );

  Widget _buildItemDress(String dress) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            Images.SHIRT,
            width: UIHelper.size(43),
            height: UIHelper.size(43),
            color: Colors.grey,
          ),
          Image.asset(
            Images.SHIRT,
            width: UIHelper.size40,
            height: UIHelper.size40,
            color: parseColor(dress),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UIHelper.horizontalSpaceSmall,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ImageWidget(
                    source: _team1.logo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size(80),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: UIHelper.size15),
                    child: Text(
                      _team1.name,
                      textAlign: TextAlign.center,
                      style: textStyleSemiBold(size: 18),
                    ),
                  )
                ],
              ),
            ),
            Image.asset(
              Images.FIND_MATCH,
              width: UIHelper.size50,
              height: UIHelper.size50,
              color: Colors.red,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ImageWidget(
                    source: _team2.logo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size(80),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: UIHelper.size15),
                    child: Text(
                      _team2.name,
                      textAlign: TextAlign.center,
                      style: textStyleSemiBold(size: 18),
                    ),
                  )
                ],
              ),
            ),
            UIHelper.horizontalSpaceSmall,
          ],
        ),
        UIHelper.verticalSpaceLarge,
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
                style: textStyleSemiBold(),
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
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: UIHelper.size10, horizontal: UIHelper.size15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildItemDress(_team1.dress),
              Text(
                'Trang phục',
                style: textStyleSemiBold(),
              ),
              _buildItemDress(_team2.dress),
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
                  'Xem thêm đánh giá',
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
