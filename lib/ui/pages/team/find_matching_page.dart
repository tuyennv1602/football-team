import 'package:flutter/material.dart';
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
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/tabbar-widget.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/viewmodels/find_matching_viewmodel.dart';
import 'package:provider/provider.dart';

class FindMatchingPage extends StatelessWidget {
  static const TABS = ['Tìm đối tác', 'Lời mời ghép đối'];

  Widget _renderNoMatchingInfo(BuildContext context) =>
      Center(
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

  Widget _buildFindMatching(BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text('finding')],
      );

  Widget _buildInvited(BuildContext context) =>
      EmptyWidget(message: 'Không có lời mời nào');

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    Team _team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Tìm đối tác',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.SEARCH,
              onTap: () => Routes.routeToSearchTeam(context),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: DefaultTabController(
                length: TABS.length,
                child: BaseWidget<FindMatchingViewModel>(
                  model: FindMatchingViewModel(
                      api: Provider.of(context),
                      teamServices: Provider.of(context)),
                  child: TabBarWidget(
                    titles: TABS,
                  ),
                  builder: (c, model, child) {
                    return Column(
                      children: <Widget>[
                        child,
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              _team.groupMatchingInfo.length == 0
                                  ? _renderNoMatchingInfo(context)
                                  : _buildFindMatching(context),
                              _buildInvited(context)
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
