import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/ticket.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/fonts.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar_widget.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/status_indicator.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/ticket_vm.dart';
import 'package:provider/provider.dart';

class TicketPage extends StatelessWidget {
  Widget _buildItemTicket(
      BuildContext context, TicketViewModel model, int index) {
    Ticket ticket = model.tickets[index];
    return BorderItem(
      onTap: () => UIHelper.showConfirmDialog(
        '${ticket.isOverTime ? 'Đã quá giờ huỷ vé. Nếu tiếp tục huỷ, bạn sẽ không được hoàn tiền cọc.\n' : ''}Bạn có chắc muốn huỷ vé #${ticket.id}?',
        onConfirmed: () => model.cancelBooking(index, ticket.id),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(
                    Images.CLOCK,
                    width: UIHelper.size20,
                    height: UIHelper.size20,
                    color: Colors.deepPurpleAccent,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: UIHelper.size15),
                      child: Text(
                        ticket.getFullPlayTime,
                        style: textStyleMediumTitle(),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: UIHelper.size10),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      Images.STADIUM,
                      width: UIHelper.size20,
                      height: UIHelper.size20,
                      color: Colors.green,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: UIHelper.padding),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: ticket.fieldName,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: MEDIUM,
                                  fontSize: UIHelper.size(16),
                                ),
                              ),
                              TextSpan(
                                text: ' - ${ticket.groundName}',
                                style: TextStyle(
                                  fontFamily: REGULAR,
                                  color: Colors.black87,
                                  fontSize: UIHelper.size(16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: UIHelper.size10),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      Images.TRANSACTIONS,
                      width: UIHelper.size20,
                      height: UIHelper.size20,
                      color: Colors.amber,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: UIHelper.padding),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Tổng: ',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: REGULAR,
                                  fontSize: UIHelper.size(16),
                                ),
                              ),
                              TextSpan(
                                text: ticket.getPrice,
                                style: TextStyle(
                                  fontFamily: MEDIUM,
                                  color: Colors.black87,
                                  fontSize: UIHelper.size(16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Đặt cọc: ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: REGULAR,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                            TextSpan(
                              text: StringUtil.formatCurrency(0),
                              style: TextStyle(
                                fontFamily: MEDIUM,
                                color: Colors.black87,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: UIHelper.padding),
            child: LineWidget(indent: 0),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  ticket.getBookingDate,
                  style: textStyleRegularBody(color: Colors.grey),
                ),
              ),
              StatusIndicator(
                status: ticket.getPaymentStatus,
                statusName: ticket.getPaymentName,
              )
            ],
          )
        ],
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
              'Vé đặt sân',
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
              child: BaseWidget<TicketViewModel>(
                  model: TicketViewModel(api: Provider.of(context)),
                  onModelReady: (model) =>
                      model.getTickets(Provider.of<Team>(context).id),
                  builder: (c, model, child) => model.busy
                      ? LoadingWidget()
                      : model.tickets.length == 0
                          ? EmptyWidget(message: 'Chưa có thông tin đặt sân')
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  vertical: UIHelper.padding),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (c, index) =>
                                  _buildItemTicket(context, model, index),
                              separatorBuilder: (c, index) =>
                                  UIHelper.verticalIndicator,
                              itemCount: model.tickets.length)),
            ),
          ),
          UIHelper.homeButtonSpace
        ],
      ),
    );
  }
}
