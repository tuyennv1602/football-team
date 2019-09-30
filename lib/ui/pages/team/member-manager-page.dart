import 'package:flutter/material.dart';
import 'package:myfootball/models/team_request.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image-widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/tabbar-widget.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/viewmodels/member_manager_viewmodel.dart';
import 'package:provider/provider.dart';

class MemberManagerPage extends StatelessWidget {
  static const TABS = ['Thành viên', 'Yêu cầu'];

  Widget _buildItemRequest(BuildContext context, TeamRequest teamRequest) =>
      InkWell(
        child: Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(UIHelper.size10),
            child: Row(
              children: <Widget>[
                ImageWidget(
                    source: teamRequest.avatar,
                    placeHolder: Images.DEFAULT_AVATAR),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text(
                      teamRequest.name ?? teamRequest.username,
                      style: textStyleRegularTitle(),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      );

  Widget _buildTeamRequests(BuildContext context, MemberMangerViewModel model) {
    if (model.busy) {
      return LoadingWidget();
    } else {
      return model.teamRequests.length > 0
          ? ListView.separated(
              padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
              itemBuilder: (c, index) =>
                  _buildItemRequest(context, model.teamRequests[index]),
              separatorBuilder: (c, index) => LineWidget(),
              itemCount: model.teamRequests.length)
          : EmptyWidget(message: 'Không có yêu cầu nào');
    }
  }

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.MORE,
              onTap: () => Navigator.of(context).pop(),
            ),
            centerContent: Text(
              'Quản lý thành viên',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: UIHelper.size10,
                ),
                child: DefaultTabController(
                  length: TABS.length,
                  child: BaseWidget<MemberMangerViewModel>(
                    model: MemberMangerViewModel(api: Provider.of(context)),
                    onModelReady: (model) => model.getTeamRequests(1),
                    child: TabBarWidget(
                      titles: TABS,
                    ),
                    builder: (c, model, child) => Column(
                      children: <Widget>[
                        child,
                        Expanded(
                          child: TabBarView(
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              Text('thanh vien'),
                              _buildTeamRequests(context, model)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
