import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myfootball/model/fixed_time.dart';
import 'package:myfootball/model/status.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/fonts.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/page/team/search_ground_page.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/button_widget.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/status_indicator.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/fixed_time_viewmodel.dart';
import 'package:provider/provider.dart';

class FixedTimeRequestPage extends StatelessWidget {
  _buildEmpty() => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          EmptyWidget(message: 'Chưa có sân cố định'),
          ButtonWidget(
            child: Text(
              'ĐẶT SÂN CỐ ĐỊNH',
              style: textStyleButton(),
            ),
            margin: EdgeInsets.symmetric(horizontal: UIHelper.size20),
            onTap: () => Navigation.instance
                .navigateTo(SEARCH_GROUND, arguments: BOOKING_TYPE.FIXED),
          )
        ],
      );

  _buildItemRequest(FixedTime request) => BorderItemWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      request.getFullPlayTime,
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
                              text: request.fieldName,
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: MEDIUM,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                            TextSpan(
                              text: ' - ${request.groundName}',
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
                              text: 'Tiền sân: ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: REGULAR,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                            TextSpan(
                              text: request.getPrice,
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: UIHelper.padding),
              child: LineWidget(indent: 0),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: request.getStatus != Status.DONE
                      ? Text(
                          request.getCreateTime,
                          style: textStyleRegularBody(color: Colors.grey),
                        )
                      : SizedBox(),
                ),
                StatusIndicator(
                  status: request.getStatus,
                  statusName: request.getStatusName,
                ),
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var teamId = Provider.of<Team>(context).id;
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Sân cố định',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.ADD,
              onTap: () => Navigation.instance
                  .navigateTo(SEARCH_GROUND, arguments: BOOKING_TYPE.FIXED),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<FixedTimeViewModel>(
                model: FixedTimeViewModel(
                  api: Provider.of(context),
                ),
                onModelReady: (model) => model.getAllRequests(teamId),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.times.length == 0
                        ? _buildEmpty()
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                                vertical: UIHelper.padding),
                            itemBuilder: (c, index) =>
                                _buildItemRequest(model.times[index]),
                            separatorBuilder: (c, index) =>
                                UIHelper.verticalIndicator,
                            itemCount: model.times.length),
              ),
            ),
          )
        ],
      ),
    );
  }
}
