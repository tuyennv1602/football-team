import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/models/field.dart';
import 'package:myfootball/models/ground.dart';
import 'package:myfootball/models/time_slot.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/booking_viewmodel.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatelessWidget {
  final Ground _ground;

  BookingPage({@required Ground ground}) : _ground = ground;

  _showDatePicker(
      BuildContext context, DateTime selectedDate, Function onSelected) async {
    var _now = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? _now,
        firstDate: DateTime(_now.year, _now.month, _now.day),
        lastDate: _now.add(Duration(days: 365)));
    if (picked != null && picked != selectedDate) {
      onSelected(picked);
    }
  }

  _handleBooking(
      BuildContext context, BookingViewModel model, TimeSlot timeSlot) async {
    UIHelper.showCustomizeDialog(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              child: Text(
                'Xác nhận đặt sân',
                style: textStyleSemiBold(),
              ),
            ),
            UIHelper.verticalSpaceMedium,
            Row(
              children: <Widget>[
                Text(
                  'Ngày đá:',
                  style: textStyleRegularTitle(),
                ),
                UIHelper.horizontalSpaceMedium,
                Text(
                  '${DateUtil.formatDate(model.currentDate, DateFormat('dd/MM/yyyy'))}',
                  style: textStyleSemiBold(),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Giờ đá:',
                  style: textStyleRegularTitle(),
                ),
                UIHelper.horizontalSpaceMedium,
                Text(
                  '${timeSlot.getTime}',
                  style: textStyleSemiBold(),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Giá thuê sân:',
                  style: textStyleRegularTitle(),
                ),
                UIHelper.horizontalSpaceMedium,
                Text(
                  '${StringUtil.formatCurrency(timeSlot.price)}',
                  style: textStyleSemiBold(),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Tiền đặt cọc:',
                  style: textStyleRegularTitle(),
                ),
                UIHelper.horizontalSpaceMedium,
                Text(
                  '${StringUtil.formatCurrency(_ground.deposit)}',
                  style: textStyleSemiBold(),
                ),
              ],
            ),
            UIHelper.verticalSpaceMedium,
            Text(
              '- Vui lòng đọc kỹ điều khoản đặt, huỷ sân trong phần trợ giúp',
              style: textStyleItalic(),
            ),
            Text(
              '- Vui lòng đọc kỹ nội quy của sân bóng trước khi đặt sân',
              style: textStyleItalic(),
            )
          ],
        ),
        onConfirmed: () async {
          UIHelper.showProgressDialog;
          var resp = await model.booking(_ground.id, timeSlot.id);
          UIHelper.hideProgressDialog;
          if (resp.isSuccess) {
            UIHelper.showSimpleDialog(
                'Đặt sân thành công. Bạn có thể lên lịch cho đội bóng trong mục quản trị đội bóng',
                onTap: () => Navigator.of(context).pop());
          } else {
            UIHelper.showSimpleDialog(resp.errorMessage);
          }
        });
  }

  Widget _buildTicket(BuildContext context, DateTime playDate,
      TimeSlot timeSlot, Function onTap) {
    bool isAbleBooking = DateUtil.isAbleBooking(playDate, timeSlot);
    return Opacity(
      opacity: isAbleBooking ? 1 : 0.5,
      child: DashedContainer(
        child: InkWell(
          onTap: () {
            if (isAbleBooking) {
              onTap();
            } else {
              UIHelper.showSimpleDialog('Đã quá giờ đặt sân');
            }
          },
          child: Container(
            margin: EdgeInsets.all(1),
            width: UIHelper.size(135),
            height: UIHelper.size(110),
            padding: EdgeInsets.all(UIHelper.size10),
            decoration: BoxDecoration(
                color: GREY_BACKGROUND,
                borderRadius: BorderRadius.circular(UIHelper.size5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Khung giờ',
                  style: textStyleRegularBody(color: Colors.grey),
                ),
                Text(
                  timeSlot.getTime,
                  style: textStyleRegularTitle(),
                ),
                UIHelper.verticalSpaceSmall,
                Text(
                  'Giá thuê sân',
                  style: textStyleRegularBody(color: Colors.grey),
                ),
                Text(
                  StringUtil.formatCurrency(timeSlot.price),
                  style: textStyleRegularTitle(),
                )
              ],
            ),
          ),
        ),
        dashColor: PRIMARY,
        borderRadius: UIHelper.size5,
        dashedLength: UIHelper.size10,
        blankLength: UIHelper.size10,
        strokeWidth: 1,
      ),
    );
  }

  Widget _buildFieldTicket(BuildContext context, Field field, DateTime playDate,
          Function booking) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
            child: Row(
              children: <Widget>[
                Text(
                  field.name,
                  style: textStyleSemiBold(color: PRIMARY, size: 18),
                ),
                UIHelper.horizontalSpaceMedium,
                Text(
                  '( ${StringUtil.getFieldType(field.type)} )',
                  style: textStyleRegularTitle(),
                ),
              ],
            ),
          ),
          Container(
            height: UIHelper.size(110),
            child: ListView.separated(
              itemCount: field.timeSlots.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(1),
              physics: BouncingScrollPhysics(),
              separatorBuilder: (c, index) => SizedBox(
                width: UIHelper.size10,
              ),
              shrinkWrap: true,
              itemBuilder: (c, index) => _buildTicket(
                  context,
                  playDate,
                  field.timeSlots[index],
                  () => booking(field.timeSlots[index])),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Đặt sân',
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
                child: BaseWidget<BookingViewModel>(
                  model: BookingViewModel(api: Provider.of(context)),
                  onModelReady: (model) => model.getFreeTimeSlot(_ground.id),
                  child: InkWell(
                    onTap: () =>
                        Routes.routeToGroundDetail(context, _ground.id),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(UIHelper.size5),
                          child: Container(
                            width: UIHelper.size(110),
                            height: UIHelper.size(100),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.DEFAULT_GROUND,
                              image: _ground.avatar,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpaceMedium,
                        Expanded(
                          child: SizedBox(
                            height: UIHelper.size(100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _ground.name,
                                    maxLines: 2,
                                    style: textStyleSemiBold(),
                                  ),
                                ),
                                UIHelper.verticalSpaceSmall,
                                Text(
                                  _ground.address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleRegular(),
                                ),
                                UIHelper.verticalSpaceSmall,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Đánh giá',
                                      style: textStyleRegular(),
                                    ),
                                    RatingBarIndicator(
                                      rating: _ground.rating,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.only(left: 2),
                                      itemSize: UIHelper.size20,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        Image.asset(
                          Images.NEXT,
                          width: UIHelper.size15,
                          height: UIHelper.size15,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                  builder: (c, model, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      UIHelper.verticalSpaceMedium,
                      child,
                      UIHelper.verticalSpaceMedium,
                      LineWidget(indent: 0),
                      Row(
                        children: <Widget>[
                          Text(
                            'Chọn ngày đá',
                            style: textStyleRegularTitle(),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => _showDatePicker(
                                context,
                                model.currentDate,
                                (dateTime) =>
                                    model.setDate(_ground.id, dateTime),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.size15),
                                child: Text(
                                  DateUtil.formatDate(model.currentDate,
                                      DateFormat('EEE, dd/MM/yyyy')),
                                  textAlign: TextAlign.right,
                                  style: textStyleSemiBold(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      LineWidget(indent: 0),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: UIHelper.size10),
                        child: Text(
                          'Các khung giờ trống',
                          style: textStyleRegularTitle(),
                        ),
                      ),
                      Expanded(
                        child: model.busy
                            ? LoadingWidget()
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (c, index) => _buildFieldTicket(
                                      context,
                                      model.fields[index],
                                      model.currentDate,
                                      (timeSlot) => _handleBooking(
                                          context, model, timeSlot),
                                    ),
                                separatorBuilder: (c, index) => SizedBox(
                                      height: UIHelper.size10,
                                    ),
                                itemCount: model.fields.length),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
