import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:myfootball/models/matching.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/clipper_left_widget.dart';
import 'package:myfootball/ui/widgets/clipper_right_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/find_matching_viewmodel.dart';
import 'package:provider/provider.dart';

class FindMatchingPage extends StatelessWidget {
  Widget _renderNoMatchingInfo(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                child: Image.asset(
                  Images.FIND_MATCH,
                  width: UIHelper.size(100),
                  height: UIHelper.size(100),
                  color: Colors.red,
                ),
              ),
              UIHelper.verticalSpaceLarge,
              Text(
                '- Tiêu chí ghép đối sẽ giúp bạn tự động tìm kiếm những đối tác phù hợp nhất với đội bóng của bạn',
                style: textStyleRegular(),
              ),
              UIHelper.verticalSpaceMedium,
              Text(
                '- Thay đổi tiêu chí ghép đối trong mục thiết lập ghép đối',
                style: textStyleRegular(),
              ),
              UIHelper.verticalSpaceMedium,
              Text(
                '- Bạn có thể chọn nhiều thời gian và nhiều khu vực có thể chơi để ghép đói',
                style: textStyleRegular(),
              ),
              UIHelper.verticalSpaceMedium,
              Text(
                '- Sử dụng chức năng tìm kiếm để tìm kiếm chính xác đối tác mà bạn muốn ghép',
                style: textStyleRegular(),
              ),
              UIHelper.verticalSpaceLarge,
              ButtonWidget(
                  child: Text(
                    'THIẾT LẬP GHÉP ĐỐI',
                    style: textStyleButton(),
                  ),
                  margin: EdgeInsets.symmetric(vertical: UIHelper.size40),
                  onTap: () => Routes.routeToSetupMatchingInfo(context))
            ],
          ),
        ),
      );

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

  Widget _buildItemTimeSlot(BuildContext context) => InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    '18:00',
                    style: textStyleRegularBody(),
                  ),
                  Container(
                    height: 0.5,
                    width: UIHelper.size40,
                    padding: EdgeInsets.symmetric(horizontal: UIHelper.size5),
                    color: PRIMARY,
                  ),
                  Text(
                    '19:30',
                    style: textStyleRegularBody(),
                  ),
                ],
              ),
              UIHelper.horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Sân bóng Chương Dương',
                      maxLines: 1,
                      style: textStyleRegular(),
                    ),
                    Text(
                      'Địa chỉ abc, xyz',
                      maxLines: 1,
                      style: textStyleRegularBody(color: Colors.grey),
                    )
                  ],
                ),
              ),
              Image.asset(
                Images.NEXT,
                width: UIHelper.size10,
                height: UIHelper.size10,
                color: LINE_COLOR,
              )
            ],
          ),
        ),
      );

  Widget _buildSwiperItem(BuildContext context, Team team1, Matching team2) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(UIHelper.size10),
            border: Border.all(color: PRIMARY)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UIHelper.verticalSpaceSmall,
            _buildItemCompare('Điểm', '${team1.point}', '${team2.point}'),
            _buildItemCompare('Xếp hạng', '${team1.rank}', '${team2.rank}'),
            _buildItemCompare('Đối đầu', '${team2.confrontation1}',
                '${team2.confrontation2}'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
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
                    style: textStyleRegular(),
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
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Xem thêm',
                        style: textStyleItalic(size: 14, color: PRIMARY),
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
            Text(
              'Gợi ý sân thi đấu',
              style: textStyleSemiBold(size: 14, color: PRIMARY),
            ),
            UIHelper.verticalSpaceSmall,
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (c, index) => LineWidget(indent: 0),
                itemBuilder: (c, index) => _buildItemTimeSlot(context),
                itemCount: 10,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    Team _team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: BaseWidget<FindMatchingViewModel>(
          model: FindMatchingViewModel(
              api: Provider.of(context), teamServices: Provider.of(context)),
          onModelReady: (model) => model.findMatching(_team),
          child: AppBarWidget(
            centerContent: SizedBox(),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.SEARCH,
              onTap: () => Routes.routeToSearchTeam(context),
            ),
            backgroundColor: Colors.transparent,
          ),
          builder: (c, model, child) {
            return Stack(
              children: <Widget>[
                Container(
                  height: UIHelper.size(230) + UIHelper.paddingTop,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.GROUND), fit: BoxFit.fill),
                  ),
                  child: Column(
                    children: <Widget>[
                      child,
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  ImageWidget(
                                    source: _team.logo,
                                    placeHolder: Images.DEFAULT_LOGO,
                                    size: UIHelper.size(80),
                                  ),
                                  Container(
                                    height: UIHelper.size(70),
                                    padding: EdgeInsets.all(UIHelper.size5),
                                    child: Text(
                                      _team.name,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: textStyleSemiBold(
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: UIHelper.size(80)),
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
                                    source: model.currentTeam != null
                                        ? model.currentTeam.logo
                                        : Images.DEFAULT_LOGO,
                                    placeHolder: Images.DEFAULT_LOGO,
                                    size: UIHelper.size(80),
                                  ),
                                  Container(
                                    height: UIHelper.size(70),
                                    padding: EdgeInsets.all(UIHelper.size5),
                                    child: model.currentTeam != null
                                        ? Text(
                                            model.currentTeam.groupName,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: textStyleSemiBold(
                                                color: Colors.white),
                                          )
                                        : SizedBox(),
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
                      top: UIHelper.size(200) + UIHelper.paddingTop),
                  child: BorderBackground(
                    child: model.busy
                        ? LoadingWidget()
                        : (_team.groupMatchingInfo.length == 0
                            ? _renderNoMatchingInfo(context)
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.size15),
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var _matching = model.matchings[index];
                                    return _buildSwiperItem(
                                        context, _team, _matching);
                                  },
                                  onIndexChanged: (index) =>
                                      model.changeCurrentTeam(
                                          model.matchings[index]),
                                  itemCount: model.matchings.length,
                                  itemWidth: UIHelper.screenWidth,
                                  scale: 0.9,
                                  viewportFraction: 0.85,
                                  loop: true,
                                ),
                              )),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
