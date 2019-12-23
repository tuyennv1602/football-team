import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/match_user.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/request_join_match_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class RequestJoinMatchPage extends StatelessWidget {
  final int matchId;
  List<MatchUser> acceptedUsers = [];

  RequestJoinMatchPage({Key key, @required this.matchId}) : super(key: key);

  _showRequestOptions(BuildContext context,
          {Function onAccept, Function onReject, Function onDetail}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: [
            'Tuỳ chọn',
            'Xem đánh giá',
            'Chấp nhận yêu cầu',
            'Từ chối yêu cầu',
            'Huỷ'
          ],
          onClickOption: (index) {
            if (index == 1) {
              onDetail();
            }
            if (index == 2) {
              onAccept();
            }
            if (index == 3) {
              onReject();
            }
          },
        ),
      );

  _buildItemRequest(BuildContext context, MatchUser matchUser,
          {Function onAccept, Function onReject, Function onDetail}) =>
      BorderItemWidget(
        onTap: () => _showRequestOptions(context,
            onAccept: () => onAccept(matchUser),
            onReject: () => onReject(matchUser.matchUserId),
            onDetail: () => Navigation.instance
                .navigateTo(USER_COMMENT, arguments: matchUser.id)),
        child: Row(
          children: <Widget>[
            ImageWidget(
              source: matchUser.avatar,
              placeHolder: Images.DEFAULT_AVATAR,
              boxFit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: UIHelper.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      matchUser.name,
                      style: textStyleMediumTitle(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: UIHelper.size5),
                      child: RatingBarIndicator(
                        rating: matchUser.getRating,
                        itemCount: 5,
                        itemPadding: EdgeInsets.only(right: 2),
                        itemSize: UIHelper.size15,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    Text(
                      matchUser.getCreateTime,
                      style: textStyleRegularBody(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => launch('tel://${matchUser.phone}'),
              child: Padding(
                padding: EdgeInsets.only(
                    left: UIHelper.size5,
                    top: UIHelper.size5,
                    bottom: UIHelper.size5),
                child: Image.asset(
                  Images.CALL,
                  width: UIHelper.size25,
                  height: UIHelper.size25,
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      );

  _handleAccept(
      int index, MatchUser matchUser, RequestJoinMatchViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.acceptRequest(index, matchUser.matchUserId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      acceptedUsers.add(matchUser);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  _handleReject(
      int index, int matchUserId, RequestJoinMatchViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.rejectRequest(index, matchUserId);
    UIHelper.hideProgressDialog;
    if (!resp.isSuccess) {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    var team = Provider.of<Team>(context);
    return WillPopScope(
      onWillPop: () {
        Navigation.instance.goBack(result: acceptedUsers);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: PRIMARY,
        body: Column(
          children: <Widget>[
            AppBarWidget(
              centerContent: Text(
                'Yêu cầu tham gia trận đấu',
                textAlign: TextAlign.center,
                style: textStyleTitle(),
              ),
              leftContent: AppBarButtonWidget(
                imageName: Images.BACK,
                onTap: () => Navigation.instance.goBack(result: acceptedUsers),
              ),
            ),
            Expanded(
              child: BorderBackground(
                child: BaseWidget<RequestJoinMatchViewModel>(
                  model: RequestJoinMatchViewModel(api: Provider.of(context)),
                  onModelReady: (model) =>
                      model.getAllRequests(matchId, team.id),
                  builder: (c, model, child) => model.busy
                      ? LoadingWidget()
                      : model.matchUsers.length == 0
                          ? EmptyWidget(message: 'Chưa có yêu cầu nào')
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  vertical: UIHelper.padding),
                              itemBuilder: (c, index) => _buildItemRequest(
                                  context, model.matchUsers[index],
                                  onAccept: (MatchUser matchUser) =>
                                      _handleAccept(index, matchUser, model),
                                  onReject: (matchUserId) =>
                                      _handleReject(index, matchUserId, model)),
                              separatorBuilder: (c, index) =>
                                  UIHelper.verticalIndicator,
                              itemCount: model.matchUsers.length),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
