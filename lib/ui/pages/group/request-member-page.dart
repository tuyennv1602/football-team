import 'package:flutter/material.dart';
import 'package:myfootball/blocs/request-member-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

class RequestMemberPage extends BasePage<RequestMemberBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        rightContent: AppBarButtonWidget(),
        leftContent: AppBarButtonWidget(
          imageName: 'icn_back.png',
          onTap: () => Navigator.of(context).pop(),
        ),
        centerContent: Center(
          child: Text(
            'Yêu cầu gia nhập đội bóng',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      );

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return Text("data");
  }

  @override
  void listenAppData(BuildContext context) {}

  @override
  void listenPageData(BuildContext context) {}
}
