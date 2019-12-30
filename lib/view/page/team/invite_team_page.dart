import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/invite_team_arg.dart';
import 'package:myfootball/model/matching_time_slot.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/customize_button.dart';
import 'package:myfootball/view/widget/choose_ratio.dart';
import 'package:myfootball/view/widget/input_text.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/customize_tabbar.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/invite_team_viewmodel.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class InviteTeamPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final InviteTeamArgument _inviteTeamArgument;
  int _ratio;
  String _invite;

  InviteTeamPage({@required InviteTeamArgument inviteTeamArgument})
      : _inviteTeamArgument = inviteTeamArgument;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _buildItemTimeSlot(BuildContext context, int index, bool isSelected,
          MatchingTimeSlot timeSlot, Function onTap) =>
      InkWell(
        onTap: () => Navigation.instance
            .navigateTo(GROUND_DETAIL, arguments: timeSlot.groundId),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: UIHelper.size5, right: UIHelper.size10),
                child: Column(
                  children: <Widget>[
                    Text(
                      timeSlot.getStartTime,
                      style: textStyleRegular(),
                    ),
                    Container(
                      height: 1,
                      width: UIHelper.size45,
                      padding: EdgeInsets.symmetric(horizontal: UIHelper.size5),
                      color: PRIMARY,
                    ),
                    Text(
                      timeSlot.getEndTime,
                      style: textStyleRegular(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      timeSlot.groundName,
                      maxLines: 1,
                      style: textStyleRegular(size: 15),
                    ),
                    Text(
                      'Giá sân: ${timeSlot.getPrice}',
                      maxLines: 1,
                      style: textStyleRegularBody(color: Colors.grey),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: UIHelper.size40,
                width: UIHelper.size50,
                child: Checkbox(
                    value: isSelected,
                    activeColor: PRIMARY,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) => onTap(value, timeSlot)),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          CustomizeAppBar(
            centerContent: Text(
              'Mời đối tác',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButton(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: UIHelper.size10, left: UIHelper.padding, right: UIHelper.padding),
                    child: Form(
                      key: _formKey,
                      child: InputText(
                        validator: (value) {
                          if (value.isEmpty) return 'Vui lòng nhập lời mời';
                          return null;
                        },
                        maxLines: 3,
                        inputType: TextInputType.text,
                        inputAction: TextInputAction.done,
                        labelText: 'Nội dung lời mời',
                        onSaved: (text) => _invite = text,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: UIHelper.padding),
                    child: ChooseRatio(
                      onSelectedType: (type) => _ratio = type,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: UIHelper.size10),
                    padding: EdgeInsets.only(
                        top: UIHelper.size10, bottom: UIHelper.size5, left: UIHelper.padding, right: UIHelper.padding),
                    child: Text(
                      'Chọn ngày, giờ, sân',
                      style: textStyleMediumTitle(),
                    ),
                  ),
                  Expanded(
                    child: BaseWidget<InviteTeamViewModel>(
                      model: InviteTeamViewModel(api: Provider.of(context)),
                      builder: (c, model, child) => DefaultTabController(
                        length: _inviteTeamArgument.mappedTimeSlots.length,
                        child: Column(
                          children: <Widget>[
                            CustomizeTabBar(
                              titles: _inviteTeamArgument.mappedTimeSlots.keys
                                  .toList()
                                  .map((item) => DateFormat('dd/MM')
                                      .format(DateUtil.getDateMatching(item)))
                                  .toList(),
                              isScrollable: true,
                              height: UIHelper.size35,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: UIHelper.padding),
                                child: TabBarView(
                                  children: _inviteTeamArgument
                                      .mappedTimeSlots.values
                                      .toList()
                                      .map(
                                        (timeSlots) => ListView.separated(
                                            physics: BouncingScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (c, index) =>
                                                _buildItemTimeSlot(
                                                    context,
                                                    index,
                                                    model.selectedTimeSlots
                                                        .contains(
                                                            timeSlots[index]),
                                                    timeSlots[index],
                                                    (isSelected, timeSlot) {
                                                  if (isSelected) {
                                                    model
                                                        .addTimeSlots(timeSlot);
                                                  } else {
                                                    model.removeTimeSlot(
                                                        timeSlot);
                                                  }
                                                }),
                                            separatorBuilder: (c, index) =>
                                                LineWidget(
                                                  indent: 0,
                                                ),
                                            itemCount: timeSlots.length),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            CustomizeButton(
                              margin: EdgeInsets.symmetric(
                                  vertical: UIHelper.size5, horizontal: UIHelper.padding),
                              child: Text(
                                'GỬI LỜI MỜI',
                                style: textStyleButton(),
                              ),
                              onTap: () {
                                if (validateAndSave()) {
                                  model.sendInvite(InviteRequest(
                                      title: _invite,
                                      sendGroupId:
                                          _inviteTeamArgument.fromTeamId,
                                      receiveGroupId:
                                          _inviteTeamArgument.toTeamId,
                                      ratio: _ratio,
                                      matchingTimeSlots:
                                          model.selectedTimeSlots));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  UIHelper.homeButtonSpace
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
