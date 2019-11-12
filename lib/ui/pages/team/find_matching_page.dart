import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/models/matching.dart';
import 'package:myfootball/models/matching_time_slot.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/pages/team/search_team_page.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/clipper_left_widget.dart';
import 'package:myfootball/ui/widgets/clipper_right_widget.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/tabbar_widget.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/find_matching_viewmodel.dart';
import 'package:provider/provider.dart';

class FindMatchingPage extends StatelessWidget {
  Widget _renderNoMatchingInfo(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: UIHelper.size20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '- Tiêu chí ghép đối sẽ giúp bạn tự động tìm kiếm những đối tác phù hợp nhất với đội bóng của bạn',
              style: textStyleRegular(),
            ),
            UIHelper.verticalSpaceMedium,
            Text(
              '- Tiêu chí ghép đối sẽ giúp mọi người có thể tìm đến bạn phù hợp với những tiêu chí bạn đã đặt ra',
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
              '- Sử dụng chức năng tìm kiếm để tìm kiếm thủ công đối tác mà bạn muốn ghép',
              style: textStyleRegular(),
            ),
            UIHelper.verticalSpaceLarge,
            ButtonWidget(
                child: Text(
                  'THIẾT LẬP GHÉP ĐỐI',
                  style: textStyleButton(),
                ),
                margin: EdgeInsets.only(top: UIHelper.size40),
                onTap: () => Routes.routeToSetupMatchingInfo(context))
          ],
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

  Widget _buildItemTimeSlot(BuildContext context, MatchingTimeSlot timeSlot) =>
      InkWell(
        onTap: () => Routes.routeToGroundDetail(context, timeSlot.groundId),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
          child: Row(
            children: <Widget>[
              UIHelper.horizontalSpaceSmall,
              Column(
                children: <Widget>[
                  Text(
                    DateUtil.getTimeStringFromDouble(timeSlot.startTime),
                    style: textStyleRegular(),
                  ),
                  Container(
                    height: 1,
                    width: UIHelper.size45,
                    padding: EdgeInsets.symmetric(horizontal: UIHelper.size5),
                    color: PRIMARY,
                  ),
                  Text(
                    DateUtil.getTimeStringFromDouble(timeSlot.endTime),
                    style: textStyleRegular(),
                  ),
                ],
              ),
              UIHelper.horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      timeSlot.groundName,
                      maxLines: 1,
                      style: textStyleRegular(size: 15),
                    ),
                    Text(
                      'Giá sân: ${StringUtil.formatCurrency(timeSlot.price)}',
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

  Widget _buildSwiperItem(BuildContext context, Team team1, Matching team2) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIHelper.size10),
        border: Border.all(color: PRIMARY),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
              child: DefaultTabController(
                length: team2.getMappedTimeSlot.length,
                child: NestedScrollView(
                  body: TabBarView(
                    children: team2.getMappedTimeSlot.values
                        .toList()
                        .map((timeSlots) => ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (c, index) =>
                                _buildItemTimeSlot(context, timeSlots[index]),
                            separatorBuilder: (c, index) => LineWidget(indent: 0),
                            itemCount: timeSlots.length))
                        .toList(),
                  ),
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      child: SliverAppBar(
                        expandedHeight: 200,
                        forceElevated: false,
                        backgroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              UIHelper.verticalSpaceSmall,
                              _buildItemCompare(
                                  'Điểm', '${team1.point}', '${team2.point}'),
                              _buildItemCompare(
                                  'Xếp hạng', '${team1.rank}', '${team2.rank}'),
                              _buildItemCompare(
                                  'Đối đầu',
                                  '${team2.confrontation1}',
                                  '${team2.confrontation2}'),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.size5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RatingBarIndicator(
                                      rating: 2.5,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.only(right: 2),
                                      itemSize: UIHelper.size15,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),

                                    Text(
                                      'Đánh giá',
                                      style: textStyleRegular(),
                                    ),
                                    RatingBarIndicator(
                                      rating: 2.5,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.only(left: 2),
                                      itemSize: UIHelper.size15,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.size5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: UIHelper.size5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Xem thêm',
                                          style: textStyleItalic(
                                              size: 13, color: PRIMARY),
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
                            ],
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Gợi ý sân thi đấu',
                                style: textStyleSemiBold(size: 14),
                              ),
                              TabBarWidget(
                                titles: team2.getMappedTimeSlot.keys
                                    .toList()
                                    .map((item) => DateUtil.formatDate(DateUtil.getDateMatching(item), DateFormat('dd/MM')))
                                    .toList(),
                                isScrollable: true,
                                height: UIHelper.size35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => Routes.routeToInviteTeam(context, team1.id, team2.groupId, team2.getMappedTimeSlot),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
              decoration: BoxDecoration(
                color: PRIMARY,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(UIHelper.size10),
                  bottomRight: Radius.circular(UIHelper.size10),
                ),
              ),
              child: Text(
                'MỜI GHÉP ĐỐI',
                style: textStyleButton(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    Team team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: BaseWidget<FindMatchingViewModel>(
          model: FindMatchingViewModel(
              api: Provider.of(context), teamServices: Provider.of(context)),
          onModelReady: (model) {
            if (team.groupMatchingInfo.length > 0) {
              model.findMatching(team);
            }
          },
          child: AppBarWidget(
            centerContent: SizedBox(),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.SEARCH,
              onTap: () => Routes.routeToSearchTeam(context, SEARCH_TYPE.COMPARE_TEAM),
            ),
            backgroundColor: Colors.transparent,
          ),
          builder: (c, model, child) {
            return Stack(
              children: <Widget>[
                Container(
                  height: UIHelper.size(210) + UIHelper.paddingTop,
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
                                    source: team.logo,
                                    placeHolder: Images.DEFAULT_LOGO,
                                    size: UIHelper.size(70),
                                  ),
                                  Container(
                                    height: UIHelper.size(70),
                                    padding: EdgeInsets.all(UIHelper.size5),
                                    child: Text(
                                      team.name,
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
                                  model.currentTeam != null
                                      ? ImageWidget(
                                          source: model.currentTeam.logo,
                                          placeHolder: Images.DEFAULT_LOGO,
                                          size: UIHelper.size(70),
                                        )
                                      : Image.asset(
                                          Images.DEFAULT_LOGO,
                                          height: UIHelper.size(70),
                                          width: UIHelper.size(70),
                                        ),
                                  Container(
                                    height: UIHelper.size(70),
                                    padding: EdgeInsets.all(UIHelper.size5),
                                    child: Text(
                                      model.currentTeam != null
                                          ? model.currentTeam.groupName
                                          : '?',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: textStyleSemiBold(
                                          color: Colors.white),
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
                    child: team.groupMatchingInfo.length == 0
                        ? _renderNoMatchingInfo(context)
                        : (model.busy
                            ? LoadingWidget()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.size10),
                                child: model.matchings.length > 0
                                    ? Swiper(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var _matching =
                                              model.matchings[index];
                                          return _buildSwiperItem(
                                              context, team, _matching);
                                        },
                                        onIndexChanged: (index) =>
                                            model.changeCurrentTeam(
                                                model.matchings[index]),
                                        itemCount: model.matchings.length,
                                        itemWidth: UIHelper.screenWidth,
                                        scale: 0.9,
                                        viewportFraction: 0.87,
                                        loop: false,
                                      )
                                    : EmptyWidget(
                                        message: 'Không tìm thấy kết quả'),
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
