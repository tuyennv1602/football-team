import 'package:flutter/material.dart';
import 'package:myfootball/blocs/member-manager-bloc.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/tabbar-widget.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/res/colors.dart';

// ignore: must_be_immutable
class MemberManagerPage extends BasePage<MemberMagagerBloc> {
  static const TABS = ['Thành viên', 'Yêu cầu'];

  @override
  Widget buildAppBar(BuildContext context) {
    return AppBarWidget(
      leftContent: AppBarButtonWidget(
        imageName: Images.BACK,
        onTap: () => Navigator.of(context).pop(),
      ),
      centerContent: Text(
        'Quản lý thành viên',
        textAlign: TextAlign.center,
        style: textStyleTitle(),
      ),
    );
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return BorderBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: size10,
        ),
        child: DefaultTabController(
          length: TABS.length,
          child: Column(
            children: <Widget>[
              TabBarWidget(
                titles: TABS,
              ),
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: TABS.map((item) => Text(item)).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void listenData(BuildContext context) {}
}
