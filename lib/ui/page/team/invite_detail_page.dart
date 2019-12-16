import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/matching_time_slot.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/button_widget.dart';
import 'package:myfootball/ui/widget/expandable_text_widget.dart';
import 'package:myfootball/ui/widget/item_option.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/tabbar_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/confirm_invite_viewmodel.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class InviteDetailPage extends StatelessWidget {
  final InviteRequest _inviteRequest;

  InviteDetailPage({@required InviteRequest inviteRequest})
      : _inviteRequest = inviteRequest;

  Widget _buildItemTimeSlot(
      BuildContext context,
      MatchingTimeSlot selectedTimeSlot,
      MatchingTimeSlot timeSlot,
      Function onTap) {
    bool isSelected = selectedTimeSlot != null &&
        selectedTimeSlot.timeSlotId == timeSlot.timeSlotId;
    return InkWell(
      onTap: () => NavigationService.instance
          .navigateTo(GROUND_DETAIL, arguments: timeSlot.groundId),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
        child: Row(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: UIHelper.size5, right: UIHelper.size10),
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
                onChanged: (value) => onTap(value, timeSlot),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Chi tiết lời mời',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ItemOptionWidget(
                    Images.INVITE,
                    'Lời mời',
                    rightContent: SizedBox(),
                    iconColor: Colors.pinkAccent,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: UIHelper.size(60)),
                    child: ExpandableTextWidget(_inviteRequest.title),
                  ),
                  ItemOptionWidget(
                    Images.RATIO,
                    'Tỉ lệ kèo: ${_inviteRequest.getRatio}',
                    rightContent: SizedBox(),
                    iconColor: Colors.red,
                  ),
                  _inviteRequest.matchId == null
                      ? Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: UIHelper.size10, horizontal: UIHelper.padding),
                          child: Text(
                            'Chọn thời gian, sân thi đấu',
                            style: textStyleSemiBold(),
                          ),
                        )
                      : SizedBox(),
                  Expanded(
                    child: BaseWidget<ConfirmInviteViewModel>(
                      model: ConfirmInviteViewModel(api: Provider.of(context)),
                      onModelReady: (model) =>
                          model.setTimeSlot(_inviteRequest.groundTimeSlots),
                      builder: (c, model, child) => Column(
                        children: <Widget>[
                          Expanded(
                            child: _inviteRequest.matchId != null
                                ? Column(
                                    children: <Widget>[
                                      ItemOptionWidget(
                                        Images.CLOCK,
                                        'Thời gian: ${_inviteRequest.matchInfo.getFullPlayTime}',
                                        rightContent: SizedBox(),
                                        iconColor: Colors.deepPurpleAccent,
                                      ),
                                      ItemOptionWidget(
                                        Images.STADIUM,
                                        _inviteRequest.matchInfo.groundName,
                                        iconColor: Colors.green,
                                        onTap: () => NavigationService.instance
                                            .navigateTo(GROUND_DETAIL,
                                                arguments: _inviteRequest
                                                    .matchInfo.groundId),
                                      ),
                                    ],
                                  )
                                : DefaultTabController(
                                  length: _inviteRequest
                                      .getMappedTimeSlot.length,
                                  child: Column(
                                    children: <Widget>[
                                      TabBarWidget(
                                        titles: _inviteRequest
                                            .getMappedTimeSlot.keys
                                            .toList()
                                            .map((item) => DateFormat(
                                                    'dd/MM')
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        item)))
                                            .toList(),
                                        isScrollable: true,
                                        height: UIHelper.size35,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: UIHelper.padding),                                              child: TabBarView(
                                            children: _inviteRequest
                                                .getMappedTimeSlot.values
                                                .toList()
                                                .map(
                                                  (timeSlots) =>
                                                      ListView.separated(
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          padding: EdgeInsets
                                                              .zero,
                                                          itemBuilder: (c, index) => _buildItemTimeSlot(
                                                              context,
                                                              model
                                                                  .selectedTimeSlot,
                                                              timeSlots[
                                                                  index],
                                                              (isSelected,
                                                                      timeSlot) =>
                                                                  model.setSelectedTimeSlot(
                                                                      !isSelected
                                                                          ? null
                                                                          : timeSlot)),
                                                          separatorBuilder:
                                                              (c, index) =>
                                                                  LineWidget(
                                                                    indent: 0,
                                                                  ),
                                                          itemCount: timeSlots
                                                              .length),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: UIHelper.padding,
                                vertical: UIHelper.size10),
                            child: _inviteRequest.isMine
                                ? ButtonWidget(
                                    child: Text(
                                      'HUỶ LỜI MỜI',
                                      style: textStyleButton(),
                                    ),
                                    onTap: () => UIHelper.showConfirmDialog(
                                        'Bạn có chắc muốn huỷ lời mời',
                                        onConfirmed: () =>
                                            model.cancelInviteRequest(
                                                _inviteRequest.id)),
                                    backgroundColor: Colors.grey,
                                  )
                                : Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ButtonWidget(
                                          child: Text(
                                            'TỪ CHỐI',
                                            style: textStyleButton(),
                                          ),
                                          onTap: () => UIHelper.showConfirmDialog(
                                              'Bạn có chắc muốn từ chối lời mời',
                                              onConfirmed: () {
                                            model.rejectInviteRequest(
                                                _inviteRequest.id);
                                          }),
                                          backgroundColor: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                          width: UIHelper.size10, height: 10),
                                      Expanded(
                                        child: ButtonWidget(
                                          child: Text(
                                            'ĐỒNG Ý',
                                            style: textStyleButton(),
                                          ),
                                          onTap: () {
                                            if (_inviteRequest.matchId ==
                                                null) {
                                              if (model.selectedTimeSlot ==
                                                  null) {
                                                UIHelper.showSimpleDialog(
                                                    'Vui lòng chọn ngày, giờ, sân thi đấu');
                                              } else {
                                                UIHelper.showConfirmDialog(
                                                    'Xác nhận lời mời',
                                                    onConfirmed: () => model
                                                        .acceptInviteRequest(
                                                            _inviteRequest.id));
                                              }
                                            } else {
                                              UIHelper.showConfirmDialog(
                                                  'Xác nhận lời mời',
                                                  onConfirmed: () =>
                                                      model.acceptJoinMatch(
                                                          _inviteRequest.id));
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                          )
                        ],
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
