import 'package:flutter/material.dart';
import 'package:myfootball/models/invite_request.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/invite_request_viewmodel.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class InviteRequestPage extends StatelessWidget {
  Widget _buildItemRequest(BuildContext context, InviteRequest inviteRequest) =>
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.size15),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
        child: InkWell(
          onTap: () => Routes.routeToConfirmInvite(context, inviteRequest),
          child: Padding(
            padding: EdgeInsets.all(UIHelper.size10),
            child: Row(
              children: <Widget>[
                ImageWidget(
                  source: inviteRequest.sendGroupLogo,
                  placeHolder: Images.DEFAULT_LOGO,
                ),
                UIHelper.horizontalSpaceMedium,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        inviteRequest.sendGroupName,
                        style: textStyleSemiBold(),
                      ),
                      Text(
                        inviteRequest.title,
                        style: textStyleRegularTitle(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            inviteRequest.getCreateTime,
                            style: textStyleRegularBody(color: Colors.grey),
                          ),
                          Text(
                            inviteRequest.getStatus,
                            style: textStyleRegularBody(
                                color: inviteRequest.getStatusColor),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    var team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Lời mời ghép đối',
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
              child: BaseWidget<InviteRequestViewModel>(
                model: InviteRequestViewModel(
                  api: Provider.of(context),
                ),
                onModelReady: (model) => model.getAllInvites(team.id),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : ListView.separated(
                        padding:
                            EdgeInsets.symmetric(vertical: UIHelper.size10),
                        itemBuilder: (c, index) => _buildItemRequest(
                            context, model.inviteRequests[index]),
                        separatorBuilder: (c, index) => SizedBox(
                              height: UIHelper.size10,
                            ),
                        itemCount: model.inviteRequests.length),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
