import 'package:flutter/material.dart';
import 'package:myfootball/blocs/request-member-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/search-widget.dart';

class RequestMemberPage extends BasePage<RequestMemberBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        rightContent: AppBarButtonWidget(
          imageName: Images.STACK,
          onTap: () => Navigator.of(context).pop(),
        ),
        leftContent: AppBarButtonWidget(
          imageName: Images.BACK,
          onTap: () => Navigator.of(context).pop(),
        ),
        centerContent: Text(
          'Yêu cầu gia nhập đội bóng',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      );

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SearchWidget(
                hintText: 'Nhập tên đội bóng',
              ),
            ),
            ButtonWidget(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 10),
              child: Image.asset(
                Images.QR_SEARCH,
                width: 25,
                height: 25,
                color: Colors.grey,
              ),
              onTap: () {},
            )
          ],
        )
      ],
    );
  }

  @override
  void listenAppData(BuildContext context) {}

  @override
  void listenPageData(BuildContext context) {}
}
