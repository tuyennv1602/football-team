import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/choose_ratio_widget.dart';
import 'package:myfootball/ui/widgets/clipper_left_widget.dart';
import 'package:myfootball/ui/widgets/clipper_right_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/input_text_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:provider/provider.dart';

class CompareTeamPage extends StatelessWidget {
  final Team _team2;

  CompareTeamPage({@required Team team}) : _team2 = team;

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
    Team _team1 = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: <Widget>[
            Container(
              height: UIHelper.size(210) + UIHelper.paddingTop,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Images.GROUND), fit: BoxFit.fill),
              ),
              child: Column(
                children: <Widget>[
                  AppBarWidget(
                    centerContent: SizedBox(),
                    leftContent: AppBarButtonWidget(
                      imageName: Images.BACK,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              ImageWidget(
                                source: _team1.logo,
                                placeHolder: Images.DEFAULT_LOGO,
                                size: UIHelper.size(70),
                              ),
                              Container(
                                height: UIHelper.size(70),
                                padding: EdgeInsets.all(UIHelper.size5),
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
                        Padding(
                          padding: EdgeInsets.only(bottom: UIHelper.size(80)),
                          child: Image.asset(
                            Images.FIND_MATCH,
                            width: UIHelper.size50,
                            height: UIHelper.size50,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              ImageWidget(
                                source: _team2.logo,
                                placeHolder: Images.DEFAULT_LOGO,
                                size: UIHelper.size(70),
                              ),
                              Container(
                                height: UIHelper.size(70),
                                padding: EdgeInsets.all(UIHelper.size5),
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
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: UIHelper.size(180) + UIHelper.paddingTop),
              child: BorderBackground(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            vertical: UIHelper.size5,
                            horizontal: UIHelper.size15),
                        children: <Widget>[
                          UIHelper.verticalSpaceSmall,
                          _buildItemCompare(
                              'Điểm', '${_team1.point}', '${_team2.point}'),
                          _buildItemCompare(
                              'Xếp hạng', '${_team1.rank}', '${_team2.rank}'),
                          _buildItemCompare('Đối đầu', '0', '0'),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: UIHelper.size5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RatingBarIndicator(
                                  rating: _team1.rating,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.only(right: 2),
                                  itemSize: UIHelper.size15,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: PRIMARY,
                                  ),
                                ),
                                Text(
                                  'Đánh giá',
                                  style: textStyleRegular(),
                                ),
                                RatingBarIndicator(
                                  rating: _team2.rating,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.only(left: 2),
                                  itemSize: UIHelper.size15,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: PRIMARY,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: UIHelper.size5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: UIHelper.size10,
                                  width: 100,
                                  child: ClipPath(
                                    clipper: ClipperLeftWidget(),
                                    child: Container(
                                      color: parseColor(_team1.dress),
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
                                      color: parseColor(_team2.dress),
                                      child: SizedBox(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () => NavigationService.instance.navigateTo(TEAM_DETAIL, arguments: _team2),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.size5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Xem thêm',
                                      style: textStyleItalic(
                                          size: 14, color: PRIMARY),
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    Image.asset(
                                      Images.NEXT,
                                      width: UIHelper.size10,
                                      height: UIHelper.size10,
                                      color: LINE_COLOR,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InputTextWidget(
                            labelText: 'Nội dung lời mời',
                            maxLines: 3,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: UIHelper.size10),
                            child: ChooseRatioTypeWidget(
                              onSelectedType: (type) => print(type),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ButtonWidget(
                        child: Text(
                          'GỬI LỜI MỜI',
                          style: textStyleButton(),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: UIHelper.size15,
                            vertical: UIHelper.size10),
                        onTap: () {})
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
