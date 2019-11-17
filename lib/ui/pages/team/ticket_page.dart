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

  _showAuthenticationBottomSheet(BuildContext context) => showModalBottomSheet(
    context: context,
    builder: (c) => AuthenticationWidget(
      onAuthentication: (isSuccess) {
        if (isSuccess) {
          Navigator.of(context).pop();
        }
      },
    ),
  );

  Widget _buildItemTicket(
      BuildContext context, TicketViewModel model, int index) {
    Ticket ticket = model.tickets[index];
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.size10),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
      child: InkWell(
        onTap: () => _showOptions(context,
            onCancel: () => UIHelper.showConfirmDialog(
                  '${ticket.isOverTime ? 'Đã quá giờ huỷ vé. Nếu tiếp tục huỷ, bạn sẽ không được hoàn tiền cọc.\n' : ''}Bạn có chắc muốn huỷ vé #${ticket.id}?',
                  onConfirmed: () => model.cancelBooking(index, ticket.id),
                ),
            onPay: () => _showAuthenticationBottomSheet(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(UIHelper.size10, UIHelper.size10,
                  UIHelper.size10, UIHelper.size5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'ID #${ticket.id}',
                    style: textStyleSemiBold(color: Colors.grey),
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
              padding: EdgeInsets.all(UIHelper.size10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        Images.CLOCK,
                        width: UIHelper.size15,
                        height: UIHelper.size15,
                        color: Colors.grey,
                      ),
                      UIHelper.horizontalSpaceMedium,
                      Text(
                        ticket.getFullPlayTime,
                        style: textStyleSemiBold(),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    children: <Widget>[
                      Image.asset(
                        Images.MARKER,
                        width: UIHelper.size15,
                        height: UIHelper.size15,
                        color: Colors.grey,
                      ),
                      UIHelper.horizontalSpaceMedium,
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '${ticket.fieldName}',
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: SEMI_BOLD,
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
                      )
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    children: <Widget>[
                      Image.asset(
                        Images.TRANSACTIONS,
                        width: UIHelper.size15,
                        height: UIHelper.size15,
                        color: Colors.grey,
                      ),
                      UIHelper.horizontalSpaceMedium,
                      RichText(
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
                              text: StringUtil.formatCurrency(ticket.price),
                              style: TextStyle(
                                fontFamily: SEMI_BOLD,
                                color: Colors.black87,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      UIHelper.horizontalSpaceLarge,
                      RichText(
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
                                fontFamily: SEMI_BOLD,
                                color: Colors.black87,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
    UIHelper().init(context);
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
              onTap: () => NavigationService.instance().goBack(),
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
                                  vertical: UIHelper.size10),
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
