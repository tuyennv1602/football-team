import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/input_score_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/match_history_viewmodel.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class MatchHistoryPage extends StatelessWidget {
  void _showManagerOptions(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: [
            'Tuỳ chọn',
            'Cập nhật tỉ số',
            'Thanh toán tiền sân',
            'Thông tin trận đấu',
            'Huỷ'
          ],
          onClickOption: (index) {
            if (index == 1) {
              _showUpdateScore(context);
            }
          },
        ),
      );

  void _showUpdateScore(BuildContext context) => UIHelper.showCustomizeDialog(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      ImageWidget(
                        source:
                            'https://firebasestorage.googleapis.com/v0/b/footballteam-eb70d.appspot.com/o/team%2F5-%C4%90%E1%BB%99i-b%C3%B3ng-c%E1%BB%A7a-Tuy%E1%BB%83n?alt=media',
                        placeHolder: Images.DEFAULT_LOGO,
                        size: UIHelper.size35,
                      ),
                      UIHelper.horizontalSpaceMedium,
                      Expanded(
                        child: Text(
                          'Acazia FC',
                          style: textStyleRegularTitle(),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(child: SizedBox())
              ],
            ),
            InputScoreWidget(
              onChangedText: (text) {},
            ),
            UIHelper.verticalSpaceMedium,
            InputScoreWidget(
              onChangedText: (text) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Lion FC',
                          textAlign: TextAlign.right,
                          style: textStyleRegularTitle(),
                        ),
                      ),
                      UIHelper.horizontalSpaceMedium,
                      ImageWidget(
                        source:
                            'https://firebasestorage.googleapis.com/v0/b/footballteam-eb70d.appspot.com/o/team%2F5-%C4%90%E1%BB%99i-b%C3%B3ng-c%E1%BB%A7a-Tuy%E1%BB%83n?alt=media',
                        placeHolder: Images.DEFAULT_LOGO,
                        size: UIHelper.size35,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );

  Widget _buildItemSchedule(BuildContext context, int index, Team team) {
    bool isCaptain =
        Provider.of<Team>(context).manager == Provider.of<User>(context).id;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.size15),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.size15),
      child: InkWell(
        onTap: () {
          if (isCaptain) {
            _showManagerOptions(context);
          } else {}
        },
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: ImageWidget(
                      source: team.logo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size30,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '1 - 1',
                      textAlign: TextAlign.center,
                      style: textStyleBold(size: 22),
                    ),
                  ),
                  Expanded(
                    child: ImageWidget(
                      source: team.logo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size30,
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpaceSmall,
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      team.name,
                      style: textStyleSemiBold(),
                    ),
                  ),
                  SizedBox(
                    width: UIHelper.size(100),
                  ),
                  Expanded(
                    child: Text(
                      team.name,
                      style: textStyleSemiBold(),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    index == 0 ? Images.UP : Images.DOWN,
                    width: UIHelper.size(12),
                    height: UIHelper.size(12),
                    color: index == 0 ? Colors.green : Colors.red,
                  ),
                  Text(
                    '32.1',
                    style: textStyleSemiBold(
                        size: 14,
                        color: index == 0 ? Colors.green : Colors.red),
                  )
                ],
              ),
              UIHelper.verticalSpaceMedium,
              Row(
                children: <Widget>[
                  Image.asset(
                    Images.CLOCK,
                    width: UIHelper.size15,
                    height: UIHelper.size15,
                    color: Colors.grey,
                  ),
                  UIHelper.horizontalSpaceMedium,
                  Expanded(
                    child: Text(
                      '16:00 - 17:30  18/11/19',
                      style: textStyleRegular(color: Colors.grey),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    var _team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Lịch sử thi đấu',
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
              child: BaseWidget<MatchHistoryViewModel>(
                model: MatchHistoryViewModel(api: Provider.of(context)),
                builder: (c, model, child) => ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: UIHelper.size15),
                    itemBuilder: (c, index) =>
                        _buildItemSchedule(context, index, _team),
                    separatorBuilder: (c, index) => UIHelper.verticalIndicator,
                    itemCount: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
