import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/match_schedule_viewmodel.dart';
import 'package:provider/provider.dart';

class MatchSchedulePage extends StatelessWidget {
  void _showManagerOptions(BuildContext context) =>
      showModalBottomSheet(
        context: context,
        builder: (c) =>
            BottomSheetWidget(
              options: [
                'Tuỳ chọn',
                'Cập nhật đối tác',
                'Thông tin trận đấu',
                'Thông tin đặt sân',
                'Đăng ký thi đấu',
                'Huỷ'
              ],
              onClickOption: (index) {},
            ),
      );

  void _showMemberOptions(BuildContext context) =>
      showModalBottomSheet(
        context: context,
        builder: (c) =>
            BottomSheetWidget(
              options: [
                'Tuỳ chọn',
                'Thông tin trận đấu',
                'Đăng ký thi đấu',
                'Huỷ'
              ],
              onClickOption: (index) {},
            ),
      );

  Widget _buildItemSchedule(BuildContext context, int index, Team team) {
    bool isCaptain =
        Provider
            .of<Team>(context)
            .manager == Provider
            .of<User>(context)
            .id;
    return InkWell(
      onTap: () {
        if (isCaptain) {
          _showManagerOptions(context);
        } else {
          _showMemberOptions(context);
        }
      },
      child: Column(
        children: <Widget>[
          UIHelper.verticalSpaceMedium,
          Container(
            height: UIHelper.size(80),
            padding: EdgeInsets.all(UIHelper.size5),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: UIHelper.size5,
                  left: UIHelper.size35,
                  right: UIHelper.size35,
                  child: Container(
                    height: UIHelper.size40,
                    padding:
                    EdgeInsets.symmetric(horizontal: UIHelper.size20),
                    color: SHADOW_GREEN,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            team.name,
                            style: textStyleSemiBold(size: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          height: UIHelper.size20,
                          width: UIHelper.size20,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(UIHelper.size5),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                              BorderRadius.circular(UIHelper.size10)),
                          child: Text(
                            'VS',
                            style: textStyleSemiBold(
                                color: Colors.white, size: 10),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            team.name,
                            textAlign: TextAlign.right,
                            style: textStyleSemiBold(size: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: UIHelper.size45,
                  left: 0,
                  right: 0,
                  child: Align(
                    child: Container(
                      height: UIHelper.size25,
                      width: UIHelper.size(120),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(UIHelper.size15),
                          bottomRight: Radius.circular(UIHelper.size15),
                        ),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: UIHelper.size10),
                      child: Text(
                        '16:00 18/11',
                        style:
                        textStyleSemiBold(color: Colors.white, size: 15),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: UIHelper.size50,
                      width: UIHelper.size50,
                      padding: EdgeInsets.all(UIHelper.size5),
                      decoration: BoxDecoration(
                          color: SHADOW_GREEN,
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius:
                          BorderRadius.circular(UIHelper.size25)),
                      child: ImageWidget(
                        source: team.logo,
                        placeHolder: Images.DEFAULT_LOGO,
                        size: UIHelper.size40,
                        radius: UIHelper.size20,
                      ),
                    ),
                    Container(
                      height: UIHelper.size50,
                      width: UIHelper.size50,
                      padding: EdgeInsets.all(UIHelper.size5),
                      decoration: BoxDecoration(
                          color: SHADOW_GREEN,
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius:
                          BorderRadius.circular(UIHelper.size25)),
                      child: ImageWidget(
                        source: team.logo,
                        placeHolder: Images.DEFAULT_LOGO,
                        size: UIHelper.size40,
                        radius: UIHelper.size20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            'Sân bóng Thạch Cầu',
            style: textStyleRegular(),
          ),
          UIHelper.verticalIndicator
        ],
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
              'Lịch thi đấu',
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
              child: BaseWidget<MatchScheduleViewModel>(
                model: MatchScheduleViewModel(api: Provider.of(context)),
                builder: (c, model, child) =>
                    ListView.separated(
                        padding: EdgeInsets.symmetric(
                            vertical: UIHelper.size10),
                        itemBuilder: (c, index) =>
                            _buildItemSchedule(context, index, _team),
                        separatorBuilder: (c, index) => LineWidget(),
                        itemCount: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
