import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/field.dart';
import 'package:myfootball/model/ground.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/time_slot.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar_widget.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/choose_day_of_week.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/booking_fixed_vm.dart';
import 'package:provider/provider.dart';

class BookingFixedPage extends StatelessWidget {
  final Ground _ground;

  BookingFixedPage({@required Ground ground}) : _ground = ground;

  _handleBooking(BuildContext context, int dayOfWeek, TimeSlot timeSlot,
      {Function onConfirmed}) async {
    UIHelper.showConfirmDialog(
      'confirm_booking',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Ngày đá: ${DateUtil.getDayOfWeek(dayOfWeek)} hàng tuần',
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
          Padding(
            padding: EdgeInsets.only(top: UIHelper.size10),
            child: Text(
              '- Vui lòng đọc kỹ điều khoản đặt, huỷ sân trong phần trợ giúp',
              style: textStyleItalic(color: Colors.white),
            ),
          ),
          Text(
            '- Vui lòng đọc kỹ nội quy của sân bóng trước khi đặt sân',
            style: textStyleItalic(color: Colors.white),
          )
        ],
      ),
      onConfirmed: () => onConfirmed(timeSlot.id),
    );
  }

  Widget _buildTicket(BuildContext context, TimeSlot timeSlot, Function onTap) {
    return BorderItem(
      margin: EdgeInsets.zero,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(1),
        width: UIHelper.size(130),
        height: UIHelper.size(110),
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
            Padding(
              padding: EdgeInsets.only(top: UIHelper.size5),
              child: Text(
                'Giá thuê sân',
                style: textStyleRegularBody(color: Colors.grey),
              ),
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

  Widget _buildFieldTicket(
          BuildContext context, Field field, Function booking) =>
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
                Padding(
                  padding: EdgeInsets.only(left: UIHelper.size10),
                  child: Text(
                    '( ${field.getFieldType} )',
                    style: textStyleMediumTitle(),
                  ),
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
              'Đặt sân cố định',
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
              child: Padding(
                padding: EdgeInsets.all(UIHelper.padding),
                child: BaseWidget<BookingFixedViewModel>(
                  model: BookingFixedViewModel(api: Provider.of(context)),
                  child: InkWell(
                    onTap: () => Navigation.instance
                        .navigateTo(GROUND_DETAIL, arguments: _ground.id),
                    child: Row(
                      children: <Widget>[
                        Hero(
                          tag: 'ground-${_ground.id}',
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
                            padding: EdgeInsets.only(
                                left: UIHelper.size15, right: UIHelper.size5),
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
                      SizedBox(
                        height: UIHelper.padding,
                        width: UIHelper.screenWidth,
                      ),
                      ChooseDayOfWeek(
                          onSelectedType: (type) =>
                              model.setDayOfWeek(_ground.id, type)),
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
                                      (timeSlot) => _handleBooking(
                                        context,
                                        model.dayOfWeek,
                                        timeSlot,
                                        onConfirmed: (timeSlotId) =>
                                            model.booking(
                                                Provider.of<Team>(context).id,
                                                timeSlotId),
                                      ),
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
