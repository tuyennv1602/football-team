import 'package:flutter/material.dart';
import 'package:myfootball/model/group_matching_info.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/button_widget.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/time_slider_widget.dart';
import 'package:myfootball/view/router/router_paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/setup_matching_viewmodel.dart';
import 'package:provider/provider.dart';

class SetupMatchingInfoPage extends StatelessWidget {
  _buildItemAddress(
          BuildContext context, AddressInfo addressInfo, Function onDeleted) =>
      Chip(
        key: ValueKey<String>(addressInfo.getAddress),
        backgroundColor: PRIMARY,
        deleteIconColor: Colors.red,
        label: Text(
          addressInfo.getAddress,
          style: textStyleRegular(color: Colors.white),
        ),
        onDeleted: () => onDeleted(),
      );

  _buildItemTime(BuildContext context, TimeInfo timeInfo, Function onDeleted) =>
      Chip(
        key: ValueKey<String>(timeInfo.getTimes),
        backgroundColor: PRIMARY,
        deleteIconColor: Colors.red,
        label: Text(
          timeInfo.getTimes,
          style: textStyleRegular(color: Colors.white),
        ),
        onDeleted: () => onDeleted(),
      );

  _showAddTime(BuildContext context, Function onAddTime) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => Container(
          color: Colors.transparent,
          child: Wrap(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(UIHelper.size(15)),
                      topLeft: Radius.circular(UIHelper.size(15))),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TimeSliderWidget(
                      onSelectedTime: (start, end, dayOfWeek) {
                        Navigator.of(context).pop();
                        onAddTime(start, end, dayOfWeek);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  _handleSave(int teamId, SetupMatchingInfoViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.saveMatchingInfo(teamId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã cập nhật thông tin ghép đối',
          isSuccess: true, onConfirmed: () => Navigation.instance.goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Team _team = Provider.of<Team>(context);
    List<TimeInfo> _timeInfo;
    List<AddressInfo> _addressInfo;
    if (_team.groupMatchingInfo.length > 0) {
      _timeInfo = _team.groupMatchingInfo[0].timeInfo;
      _addressInfo = _team.groupMatchingInfo[0].addressInfo;
    }
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Thiết lập ghép đối',
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
              child: BaseWidget<SetupMatchingInfoViewModel>(
                model: SetupMatchingInfoViewModel(
                    api: Provider.of(context),
                    teamServices: Provider.of(context)),
                onModelReady: (model) {
                  model.setAddressInfo(_addressInfo);
                  model.setTimeInfo(_timeInfo);
                },
                builder: (c, model, child) {
                  List<Widget> _timeChildren = [];
                  model.timeInfos.asMap().forEach(
                        (index, time) => _timeChildren.add(
                          _buildItemTime(
                            context,
                            time,
                            () => model.removeTimeInfo(index),
                          ),
                        ),
                      );
                  List<Widget> _addressChildren = [];
                  model.addressInfos.asMap().forEach(
                        (index, address) => _addressChildren.add(
                          _buildItemAddress(context, address,
                              () => model.removeAddressInfo(index)),
                        ),
                      );
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIHelper.padding,
                                  vertical: UIHelper.size10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Thời gian có thể chơi',
                                    style: textStyleMediumTitle(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(UIHelper.size10),
                                    child: InkWell(
                                      onTap: () => _showAddTime(
                                          context,
                                          (start, end, dayOfWeek) =>
                                              model.addTimeInfo(TimeInfo(
                                                  startHour: start,
                                                  endHour: end,
                                                  dayOfWeek: dayOfWeek))),
                                      child: Image.asset(
                                        Images.ADD,
                                        width: UIHelper.size20,
                                        height: UIHelper.size20,
                                        color: PRIMARY,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: UIHelper.padding,
                                  right: UIHelper.padding,
                                  bottom: UIHelper.size10),
                              child: Wrap(
                                spacing: UIHelper.size5,
                                children: _timeChildren,
                              ),
                            ),
                            LineWidget(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIHelper.padding,
                                  vertical: UIHelper.size10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Khu vực có thể chơi',
                                    style: textStyleMediumTitle(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(UIHelper.size10),
                                    child: InkWell(
                                      onTap: () async {
                                        var result = await Navigation.instance
                                            .navigateTo(SETUP_ADDRESS);
                                        if (result != null) {
                                          model.addAddressInfos(result);
                                        }
                                      },
                                      child: Image.asset(
                                        Images.ADD,
                                        width: UIHelper.size20,
                                        height: UIHelper.size20,
                                        color: PRIMARY,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIHelper.padding),
                              child: Wrap(
                                  spacing: UIHelper.size5,
                                  children: _addressChildren),
                            ),
                          ],
                        ),
                      ),
                      ButtonWidget(
                        child: Text(
                          'LƯU LẠI',
                          style: textStyleButton(),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: UIHelper.padding,
                            vertical: UIHelper.size5),
                        onTap: () => _handleSave(_team.id, model),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          UIHelper.homeButtonSpace
        ],
      ),
    );
  }
}
