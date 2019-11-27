import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/models/invite_request.dart';
import 'package:myfootball/models/matching_time_slot.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/expandable_text_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/tabbar_widget.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/confirm_invite_viewmodel.dart';
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
              child: Padding(
                padding: EdgeInsets.all(UIHelper.size10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Nội dung lời mời',
                      style: textStyleRegularBody(color: Colors.grey),
                    ),
                    ExpandableTextWidget(_inviteRequest.title),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Tỉ lệ kèo (Thắng - Thua): ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: REGULAR,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                            TextSpan(
                              text:
                                  StringUtil.getRatioName(_inviteRequest.ratio),
                              style: TextStyle(
                                fontFamily: SEMI_BOLD,
                                color: Colors.black,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    LineWidget(indent: 0),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                      child: Text(
                        'Chọn ngày, giờ, sân',
                        style: textStyleRegularTitle(),
                      ),
                    ),
                    Expanded(
                      child: BaseWidget<ConfirmInviteViewModel>(
                        model:
                            ConfirmInviteViewModel(api: Provider.of(context)),
                        onModelReady: (model) =>
                            model.setTimeSlot(_inviteRequest.groundTimeSlots),
                        builder: (c, model, child) => DefaultTabController(
                          length: _inviteRequest.getMappedTimeSlot.length,
                          child: Column(
                            children: <Widget>[
                              TabBarWidget(
                                titles: _inviteRequest.getMappedTimeSlot.keys
                                    .toList()
                                    .map((item) => DateFormat('dd/MM')
                                        .format(DateTime.fromMillisecondsSinceEpoch(item)))
                                    .toList(),
                                isScrollable: true,
                                height: UIHelper.size35,
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: _inviteRequest
                                      .getMappedTimeSlot.values
                                      .toList()
                                      .map(
                                        (timeSlots) => ListView.separated(
                                            physics: BouncingScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (c, index) =>
                                                _buildItemTimeSlot(
                                                    context,
                                                    model.selectedTimeSlot,
                                                    timeSlots[index],
                                                    (isSelected, timeSlot) =>
                                                        model.setSelectedTimeSlot(
                                                            !isSelected
                                                                ? null
                                                                : timeSlot)),
                                            separatorBuilder: (c, index) =>
                                                LineWidget(
                                                  indent: 0,
                                                ),
                                            itemCount: timeSlots.length),
                                      )
                                      .toList(),
                                ),
                              ),
                              _inviteRequest.isMine
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
                                      height: UIHelper.size45,
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
                                            height: UIHelper.size45,
                                          ),
                                        ),
                                        UIHelper.horizontalSpaceMedium,
                                        Expanded(
                                          child: ButtonWidget(
                                            child: Text(
                                              'ĐỒNG Ý',
                                              style: textStyleButton(),
                                            ),
                                            onTap: () {
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
                                            },
                                            height: UIHelper.size45,
                                          ),
                                        )
                                      ],
                                    )
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
