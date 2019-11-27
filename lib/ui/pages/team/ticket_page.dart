import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/ticket.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/authentication_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/ticket_viewmodel.dart';
import 'package:provider/provider.dart';

class TicketPage extends StatelessWidget {
  _showOptions(BuildContext context, {Function onCancel, Function onPay}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Huỷ đặt sân', 'Thanh toán sân', 'Huỷ'],
          onClickOption: (index) {
            if (index == 1) {
              onCancel();
            }
            if (index == 2) {
              onPay();
            }
          },
        ),
      );

  _showAuthenticationBottomSheet(BuildContext context, {Function onSuccess}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => AuthenticationWidget(
          onAuthentication: (isSuccess) {
            if (isSuccess) {
              Navigator.of(context).pop();
              onSuccess();
            }
          },
        ),
      );

  Widget _buildItemTicket(
      BuildContext context, TicketViewModel model, int index) {
    Ticket ticket = model.tickets[index];
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.padding),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
      child: InkWell(
        onTap: () => _showOptions(
          context,
          onCancel: () => UIHelper.showConfirmDialog(
            '${ticket.isOverTime ? 'Đã quá giờ huỷ vé. Nếu tiếp tục huỷ, bạn sẽ không được hoàn tiền cọc.\n' : ''}Bạn có chắc muốn huỷ vé #${ticket.id}?',
            onConfirmed: () => _showAuthenticationBottomSheet(
              context,
              onSuccess: () => model.cancelBooking(index, ticket.id),
            ),
          ),
          onPay: () => _showAuthenticationBottomSheet(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: UIHelper.padding, vertical: UIHelper.size10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'ID #${ticket.id}',
                    style: textStyleSemiBold(color: PRIMARY),
                  ),
                  Text(
                    'Chưa thanh toán',
                    style: textStyleRegular(color: Colors.grey),
                  )
                ],
              ),
            ),
            LineWidget(indent: 0),
            Padding(
              padding: EdgeInsets.all(UIHelper.padding),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        Images.CLOCK,
                        width: UIHelper.size20,
                        height: UIHelper.size20,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: UIHelper.size15),
                          child: Text(
                            ticket.getFullPlayTime,
                            style: textStyleSemiBold(),
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
                          Images.MARKER,
                          width: UIHelper.size20,
                          height: UIHelper.size20,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: UIHelper.padding),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${ticket.fieldName}',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: SEMI_BOLD,
                                      fontSize: UIHelper.size(17),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' - ${ticket.groundName}',
                                    style: TextStyle(
                                      fontFamily: REGULAR,
                                      color: Colors.black87,
                                      fontSize: UIHelper.size(17),
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
                          color: Colors.grey,
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
                                      fontSize: UIHelper.size(17),
                                    ),
                                  ),
                                  TextSpan(
                                    text: StringUtil.formatCurrency(ticket.price),
                                    style: TextStyle(
                                      fontFamily: SEMI_BOLD,
                                      color: Colors.black87,
                                      fontSize: UIHelper.size(17),
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
                                    fontSize: UIHelper.size(17),
                                  ),
                                ),
                                TextSpan(
                                  text: StringUtil.formatCurrency(0),
                                  style: TextStyle(
                                    fontFamily: SEMI_BOLD,
                                    color: Colors.black87,
                                    fontSize: UIHelper.size(17),
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
              'Vé đã đặt',
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
          )
        ],
      ),
    );
  }
}
