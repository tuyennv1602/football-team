import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

class MatchingInfoPage extends StatelessWidget {
  static const TABS = ['ACAZIA FC', 'Lion FC'];

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
                    Padding(
                      padding: EdgeInsets.all(UIHelper.size15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ImageWidget(
                            source: team.logo,
                            placeHolder: Images.DEFAULT_LOGO,
                          ),
                          UIHelper.horizontalSpaceLarge,
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(UIHelper.size15),
                                  bottomRight: Radius.circular(UIHelper.size15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    team.name,
                                    style: textStyleSemiBold(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: UIHelper.size(2)),
                                    child: Text(
                                      'Xếp hạng: ${team.rank} (${team.point} điểm)',
                                      style: textStyleRegular(),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Đánh giá: ',
                                        style: textStyleRegular(),
                                      ),
                                      RatingBarIndicator(
                                        rating: team.rating,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.only(left: 2),
                                        itemSize: UIHelper.size15,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: PRIMARY,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          Image.asset(
                            Images.NEXT,
                            width: UIHelper.size15,
                            height: UIHelper.size15,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    LineWidget(),
                    ItemOptionWidget(
                      Images.CLOCK,
                      '16:00 18/11/2019',
                      iconColor: Colors.red,
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
                      iconColor: Colors.amber,
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
