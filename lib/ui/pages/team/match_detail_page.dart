import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/match_schedule.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/item_option.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/tabbar_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/matching_info_viewmodel.dart';
import 'package:provider/provider.dart';

class MatchDetailPage extends StatelessWidget {
  static const TABS = ['ACAZIA FC', 'Lion FC'];

  final MatchSchedule _matchSchedule;

  MatchDetailPage({Key key, @required MatchSchedule matchSchedule})
      : _matchSchedule = matchSchedule,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    var team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Thông tin trận đấu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<MatchingInfoViewModel>(
                model: MatchingInfoViewModel(api: Provider.of(context)),
                builder: (c, model, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _matchSchedule.receiveTeam != null
                        ? InkWell(
                            onTap: () => Routes.routeToOtherTeamDetail(context, _matchSchedule.receiveTeam),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: UIHelper.size10,
                                  horizontal: UIHelper.size15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ImageWidget(
                                    source: _matchSchedule.receiveTeam.logo,
                                    placeHolder: Images.DEFAULT_LOGO,
                                    size: UIHelper.size40,
                                  ),
                                  UIHelper.horizontalSpaceMedium,
                                  Expanded(
                                    child: Text(
                                      _matchSchedule.receiveTeam.name,
                                      style: textStyleSemiBold(size: 18),
                                    ),
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
                          )
                        : SizedBox(),
                    LineWidget(),
                    ItemOptionWidget(
                      Images.CLOCK,
                      _matchSchedule.getFullPlayTime,
                      iconColor: Colors.blue,
                      rightContent: SizedBox(),
                    ),
                    LineWidget(),
                    ItemOptionWidget(
                      Images.MARKER,
                      'Sân bóng Thạch Cầu',
                      iconColor: Colors.green,
                      onTap: () => Routes.routeToGroundDetail(context, 13),
                    ),
                    LineWidget(),
                    ItemOptionWidget(
                      Images.FRAME,
                      'Tỉ lệ 50-50',
                      iconColor: Colors.red,
                      rightContent: SizedBox(),
                      onTap: () => Routes.routeToGroundDetail(context, 13),
                    ),
                    LineWidget(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: UIHelper.size15,
                          vertical: UIHelper.size10),
                      child: Text(
                        'Danh sách thi đấu',
                        style: textStyleRegularTitle(),
                      ),
                    ),
                    Expanded(
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: <Widget>[
                            TabBarWidget(
                              titles: TABS,
                              height: UIHelper.size30,
                            ),
                            Expanded(
                              child: TabBarView(children: [
                                Text('Danh sách 1'),
                                Text('Danh sách 2'),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
