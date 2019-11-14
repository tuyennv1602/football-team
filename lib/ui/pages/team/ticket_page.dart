import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/ticket.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/ticket_viewmodel.dart';
import 'package:provider/provider.dart';

class TicketPage extends StatelessWidget {
  Widget _buildItemTicket(BuildContext context, Ticket ticket) {}

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Sân bóng đã đặt',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BaseWidget<TicketViewModel>(
                model: TicketViewModel(api: Provider.of(context)),
                onModelReady: (model) =>
                    model.getTickets(Provider.of<Team>(context).id),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : ListView.separated(
                        itemBuilder: (c, index) =>
                            _buildItemTicket(context, model.tickets[index]),
                        separatorBuilder: (c, index) =>
                            UIHelper.verticalIndicator,
                        itemCount: model.tickets.length)),
          )
        ],
      ),
    );
  }
}
