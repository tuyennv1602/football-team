import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/models/invite_request.dart';
import 'package:myfootball/models/invite_team_arg.dart';
import 'package:myfootball/models/matching_time_slot.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/choose_ratio_widget.dart';
import 'package:myfootball/ui/widgets/input_text_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/tabbar_widget.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/invite_team_viewmodel.dart';
import 'package:provider/provider.dart';

class InviteTeamPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final InviteTeamArgument _inviteTeamArgument;
  int _ratio = Constants.RATIO_50_50;
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
        onTap: () => NavigationService.instance
            .navigateTo(GROUND_DETAIL, arguments: timeSlot.groundId),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
          child: Row(
            children: <Widget>[
              UIHelper.horizontalSpaceSmall,
              Column(
                children: <Widget>[
                  Text(
                    DateUtil.getTimeStringFromDouble(timeSlot.startTime),
                    style: textStyleRegular(),
                  ),
                  Container(
                    height: 1,
                    width: UIHelper.size45,
                    padding: EdgeInsets.symmetric(horizontal: UIHelper.size5),
                    color: PRIMARY,
                  ),
                  Text(
                    DateUtil.getTimeStringFromDouble(timeSlot.endTime),
                    style: textStyleRegular(),
                  ),
                ],
              ),
              UIHelper.horizontalSpaceMedium,
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
                      'Giá sân: ${StringUtil.formatCurrency(timeSlot.price)}',
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
          AppBarWidget(
            centerContent: Text(
              'Mời đối tác',
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UIHelper.verticalSpaceMedium,
                    Form(
                      key: _formKey,
                      child: InputTextWidget(
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
                    ChooseRatioTypeWidget(
                      onSelectedType: (type) => _ratio = type,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: UIHelper.size20, bottom: UIHelper.size5),
                          child: Text(
                            'Chọn ngày, giờ, sân',
                            style: textStyleRegularTitle(),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: UIHelper.size20, bottom: UIHelper.size5),
                            child: Text(
                              'Chọn tất cả',
                              style: textStyleRegularTitle(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: BaseWidget<InviteTeamViewModel>(
                        model: InviteTeamViewModel(api: Provider.of(context)),
                        builder: (c, model, child) => DefaultTabController(
                          length: _inviteTeamArgument.mappedTimeSlots.length,
                          child: Column(
                            children: <Widget>[
                              TabBarWidget(
                                titles: _inviteTeamArgument.mappedTimeSlots.keys
                                    .toList()
                                    .map((item) => DateFormat('dd/MM')
                                        .format(DateUtil.getDateMatching(item)))
                                    .toList(),
                                isScrollable: true,
                                height: UIHelper.size35,
                              ),
                              Expanded(
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
                              ButtonWidget(
                                margin: EdgeInsets.symmetric(
                                    vertical: UIHelper.size10),
                                child: Text(
                                  'GỬI LỜI MỜI',
                                  style: textStyleButton(),
                                ),
                                onTap: () {
                                  if (validateAndSave()) {
                                    model.sendInvite(InviteRequest(
                                        title: _invite,
                                        sendGroupId: _inviteTeamArgument.fromTeamId,
                                        receiveGroupId: _inviteTeamArgument.toTeamId,
                                        ratio: _ratio,
                                        matchingTimeSlots: model.selectedTimeSlots));
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
          ),
        ],
      ),
    );
  }
}
