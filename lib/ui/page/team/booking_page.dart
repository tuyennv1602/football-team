import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/model/field.dart';
import 'package:myfootball/model/ground.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/time_slot.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/authentication_widget.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/select_date.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/booking_viewmodel.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatelessWidget {
  final Ground _ground;

  BookingPage({@required Ground ground}) : _ground = ground;

  _handleBooking(
      BuildContext context, BookingViewModel model, TimeSlot timeSlot) async {
    UIHelper.showConfirmDialog(
      'confirm_booking',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Ngày đá:  ${DateFormat('dd/MM/yyyy').format(model.currentDate)}',
            style: textStyleAlert(),
          ),
          Text(
            'Giờ đá:  ${timeSlot.getTime}',
            style: textStyleAlert(),
          ),
          Text(
            'Tiền sân:  ${timeSlot.getPrice}',
            style: textStyleAlert(),
          ),
          Text(
            'Tiền đặt cọc:  ${_ground.getDeposit}',
            style: textStyleAlert(),
          ),
          UIHelper.verticalSpaceMedium,
          Text(
            '- Vui lòng đọc kỹ điều khoản đặt, huỷ sân trong phần trợ giúp',
            style: textStyleItalic(color: Colors.white),
          ),
          Text(
            '- Vui lòng đọc kỹ nội quy của sân bóng trước khi đặt sân',
            style: textStyleItalic(color: Colors.white),
          )
        ],
      ),
      onConfirmed: () => _showAuthenticationBottomSheet(
        context,
        onSuccess: () =>
            model.booking(Provider.of<Team>(context).id, timeSlot.id),
      ),
    );
  }

  _showAuthenticationBottomSheet(BuildContext context, {Function onSuccess}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => AuthenticationWidget(onAuthentication: (isSuccess) {
          if (isSuccess) {
            Navigator.of(context).pop();
            onSuccess();
          }
        }),
      );

  Widget _buildTicket(BuildContext context, DateTime playDate,
      TimeSlot timeSlot, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(1),
        width: UIHelper.size(135),
        height: UIHelper.size(110),
        padding: EdgeInsets.all(UIHelper.size10),
        decoration: BoxDecoration(
            color: GREY_BACKGROUND,
            borderRadius: BorderRadius.circular(UIHelper.size10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Khung giờ',
              style: textStyleRegularBody(color: Colors.grey),
            ),
            Text(
              timeSlot.getTime,
              style: textStyleMediumTitle(),
            ),
            UIHelper.verticalSpaceSmall,
            Text(
              'Giá thuê sân',
              style: textStyleRegularBody(color: Colors.grey),
            ),
            Text(
              timeSlot.getPrice,
              style: textStyleMediumTitle(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFieldTicket(BuildContext context, Field field, DateTime playDate,
          Function booking) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: UIHelper.padding),
            child: Row(
              children: <Widget>[
                Text(
                  field.name,
                  style: textStyleSemiBold(color: PRIMARY, size: 18),
                ),
                UIHelper.horizontalSpaceMedium,
                Text(
                  '( ${field.getFieldType} )',
                  style: textStyleMediumTitle(),
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
                width: UIHelper.padding,
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
              onTap: () => NavigationService.instance.goBack(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.INFO,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: Padding(
                padding: EdgeInsets.all(UIHelper.padding),
                child: BaseWidget<BookingViewModel>(
                  model: BookingViewModel(api: Provider.of(context)),
                  onModelReady: (model) => model.getFreeTimeSlot(_ground.id),
                  child: InkWell(
                    onTap: () => NavigationService.instance
                        .navigateTo(GROUND_DETAIL, arguments: _ground.id),
                    child: Row(
                      children: <Widget>[
                        Hero(
                          tag: _ground.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(UIHelper.size5),
                            child: Container(
                              width: UIHelper.size(90),
                              height: UIHelper.size(70),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.DEFAULT_GROUND,
                                image: _ground.avatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: UIHelper.size15),
                            child: SizedBox(
                              height: UIHelper.size(70),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _ground.name,
                                    maxLines: 1,
                                    style: textStyleSemiBold(),
                                  ),
                                  Text(
                                    _ground.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textStyleRegular(),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                  ),
                                ],
                              ),
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
                      child,
                      UIHelper.verticalSpaceMedium,
                      LineWidget(indent: 0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Chọn ngày đá',
                              style: textStyleMediumTitle(),
                            ),
                          ),
                          SelectDateWidget(
                            padding:
                                EdgeInsets.symmetric(vertical: UIHelper.size15),
                            onSelectedDate: (date) =>
                                model.setDate(_ground.id, date),
                            formatDate: 'EEE, dd/MM/yyyy',
                          ),
                        ],
                      ),
                      LineWidget(indent: 0),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: UIHelper.size10),
                        child: Text(
                          'Các khung giờ trống',
                          style: textStyleMediumTitle(),
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
