import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/viewmodels/update_schedule_viewmodel.dart';
import 'package:provider/provider.dart';

class UpdateSchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Cập nhật lịch thi đấu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget(
                model: UpdateScheduleViewModel(api: Provider.of(context)),
                builder: (c, model, child) => Column(
                  children: <Widget>[Text('data')],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
