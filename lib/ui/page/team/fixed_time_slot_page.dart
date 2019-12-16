import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/team/search_ground_page.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/button_widget.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';

class FixedTimeSlotPage extends StatelessWidget {
  _buildEmpty() => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          EmptyWidget(message: 'Chưa có sân cố định'),
          ButtonWidget(
            child: Text(
              'ĐẶT SÂN CỐ ĐỊNH',
              style: textStyleButton(),
            ),
            margin: EdgeInsets.symmetric(horizontal: UIHelper.size20),
            onTap: () => NavigationService.instance
                .navigateTo(SEARCH_GROUND, arguments: BOOKING_TYPE.FIXED),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Sân cố định',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.STACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(child: _buildEmpty()),
          ),
        ],
      ),
    );
  }
}
