import 'package:flutter/material.dart';
import 'package:myfootball/blocs/user-request-bloc.dart';
import 'package:myfootball/models/responses/user-request-response.dart';
import 'package:myfootball/models/user-request.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/image-widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/viewmodels/user_request_model.dart';
import 'package:provider/provider.dart';

class UserRequestPage extends StatelessWidget {
  Widget _buildItemRequest(BuildContext context, UserRequest request) =>
      InkWell(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ImageWidget(
                  source: request.teamLogo, placeHolder: Images.DEFAULT_LOGO),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: UIHelper.size10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Gửi tới: ${request.teamName}',
                      style: textStyleSemiBold(),
                    ),
                    Text(
                      request.content,
                      style: textStyleRegular(size: 16),
                    ),
                    Text(
                      'Ngày tạo: ${request.getCreateDate}',
                      style: textStyleItalic(color: Colors.grey),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
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
              'Tất cả yêu cầu',
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
                child: BaseWidget<UserRequestModel>(
              onModelReady: (model) => model.getAllRequest(),
              model: UserRequestModel(api: Provider.of(context)),
              builder: (context, model, child) => model.busy
                  ? LoadingWidget()
                  : ListView.separated(
                      padding: EdgeInsets.all(UIHelper.size10),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (c, index) =>
                          _buildItemRequest(context, model.userRequests[index]),
                      separatorBuilder: (c, index) => LineWidget(),
                      itemCount: model.userRequests.length),
            )),
          ),
        ],
      ),
    );
  }
}
