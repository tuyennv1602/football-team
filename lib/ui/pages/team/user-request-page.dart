import 'package:flutter/material.dart';
import 'package:myfootball/blocs/user-request-bloc.dart';
import 'package:myfootball/models/responses/user-request-response.dart';
import 'package:myfootball/models/user-request.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/image-widget.dart';
import 'package:myfootball/ui/widgets/line.dart';

// ignore: must_be_immutable
class UserRequestPage extends BasePage<UserRequestBloc> {
  @override
  Widget buildAppBar(BuildContext context) => AppBarWidget(
        centerContent: Text(
          'Tất cả yêu cầu',
          textAlign: TextAlign.center,
          style: textStyleTitle(),
        ),
        leftContent: AppBarButtonWidget(
          imageName: Images.BACK,
          onTap: () => Navigator.of(context).pop(),
        ),
      );

  Widget _buildItemRequest(BuildContext context, UserRequest request) =>
      InkWell(
        child: Padding(
          padding: EdgeInsets.all(size10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ImageWidget(
                  source: request.teamLogo, placeHolder: Images.DEFAULT_LOGO),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: size10),
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
  Widget buildMainContainer(BuildContext context) {
    return BorderBackground(
      child: StreamBuilder<UserRequestResponse>(
        stream: pageBloc.getUserRequestStream,
        builder: (c, snap) {
          if (snap.hasData) {
            var _requests = snap.data.userRequests;
            return ListView.separated(
                padding: EdgeInsets.all(size10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (c, index) =>
                    _buildItemRequest(context, _requests[index]),
                separatorBuilder: (c, index) => LineWidget(),
                itemCount: _requests.length);
          }
          return SizedBox();
        },
      ),
    );
  }

  @override
  void listenData(BuildContext context) {}
}
