import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/input_text_widget.dart';
import 'package:myfootball/view/widget/multichoice_position.dart';
import 'package:myfootball/view/widget/search_widget.dart';
import 'package:myfootball/view/router/router_paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/search_team_viewmodel.dart';
import 'package:provider/provider.dart';

enum SEARCH_TYPE {
  REQUEST_MEMBER,
  COMPARE_TEAM,
  SELECT_OPPONENT_TEAM,
  TEAM_DETAIL
}

class SearchTeamPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final SEARCH_TYPE type;

  SearchTeamPage({Key key, this.type = SEARCH_TYPE.COMPARE_TEAM})
      : super(key: key);

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _buildItemTeam(BuildContext context, Team team, {Function onSubmitRequest}) =>
      BorderItemWidget(
        onTap: () {
          if (type == SEARCH_TYPE.COMPARE_TEAM) {
            Navigation.instance.navigateTo(COMPARE_TEAM, arguments: team);
          } else if (type == SEARCH_TYPE.REQUEST_MEMBER) {
            _showOptions(
              context,
              onDetail: () =>
                  Navigation.instance.navigateTo(TEAM_DETAIL, arguments: team),
              onRequest: () =>
                  _showRequestForm(context, team, onSubmit: onSubmitRequest),
            );
          } else if (type == SEARCH_TYPE.TEAM_DETAIL) {
            Navigation.instance.navigateTo(TEAM_DETAIL, arguments: team);
          } else {
            Navigator.of(context).pop(team);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: UIHelper.padding),
              child: Hero(
                tag: 'team-${team.id}',
                child: ImageWidget(
                  source: team.logo,
                  placeHolder: Images.DEFAULT_LOGO,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(UIHelper.size15),
                    bottomRight: Radius.circular(UIHelper.size15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      team.name,
                      style: textStyleSemiBold(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                      child: Text(
                        team.bio,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: textStyleRegularBody(color: Colors.black54),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                Images.MEMBER,
                                width: UIHelper.size15,
                                height: UIHelper.size15,
                                color: Colors.green,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: UIHelper.size5),
                                child: Text(
                                  team.countMember.toString(),
                                  style:
                                      textStyleRegular(color: Colors.black87),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                Images.RANK,
                                width: UIHelper.size(13),
                                height: UIHelper.size(13),
                                color: Colors.deepPurpleAccent,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: UIHelper.size5),
                                child: Text(
                                  team.rank.toString(),
                                  style:
                                      textStyleRegular(color: Colors.black87),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: UIHelper.size20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: UIHelper.size5),
                                child: Text(
                                  team.rating.toStringAsFixed(1),
                                  style:
                                      textStyleRegular(color: Colors.black87),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  _showOptions(BuildContext context, {Function onRequest, Function onDetail}) =>
      showModalBottomSheet(
          context: context,
          builder: (c) => BottomSheetWidget(
                options: [
                  'Tuỳ chọn',
                  'Gửi yêu cầu',
                  'Thông tin đội bóng',
                  'Huỷ'
                ],
                onClickOption: (index) {
                  if (index == 1) {
                    onRequest();
                  }
                  if (index == 2) {
                    onDetail();
                  }
                },
              ));

  _showRequestForm(BuildContext context, Team team, {Function onSubmit}) {
    String _content;
    List<String> _positions;
    return UIHelper.showCustomizeDialog(
      'request_member',
      icon: Images.EDIT_PROFILE,
      confirmLabel: 'GỬI',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: InputTextWidget(
              validator: (value) {
                if (value.isEmpty) return 'Vui lòng nhập nội dung';
                return null;
              },
              onSaved: (value) => _content = value,
              maxLines: 3,
              focusedColor: Colors.white,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              labelText: 'Giới thiệu bản thân',
              textStyle: textStyleInput(color: Colors.white),
              hintTextStyle: textStyleInput(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: UIHelper.size5),
            child: Text(
              'Vị trí có thể chơi (Chọn 1 hoặc nhiều)',
              style: textStyleRegularBody(color: Colors.white),
            ),
          ),
          MultiChoicePosition(
            initPositions: [],
            onChangePositions: (positions) => _positions = positions,
          )
        ],
      ),
      onConfirmed: () {
        if (validateAndSave()) {
          if (_positions == null || _positions.length == 0) {
            UIHelper.showSimpleDialog('Bạn chưa chọn vị trí có thể chơi');
          } else {
            Navigation.instance.goBack();
            onSubmit(team.id, _content, _positions.join(','));
          }
        }
      },
    );
  }

  _handleCreateRequest(int teamId, String content, String position,
      SearchTeamViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.createRequest(teamId, content, position);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã gửi đăng ký!', isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Tìm kiếm đội bóng',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
            rightContent: type == SEARCH_TYPE.REQUEST_MEMBER
                ? AppBarButtonWidget(
                    imageName: Images.STACK,
                    onTap: () => Navigation.instance.navigateTo(USER_REQUESTS))
                : AppBarButtonWidget(),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<SearchTeamViewModel>(
                model: SearchTeamViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.searchTeamByKey(''),
                child: UIHelper.homeButtonSpace,
                builder: (context, model, child) => Column(
                  children: <Widget>[
                    SearchWidget(
                      keyword: model.key,
                      hintText: 'Nhập tên đội bóng',
                      isLoading: model.isLoading,
                      onChangedText: (text) => model.searchTeamByKey(text),
                    ),
                    model.teams == null
                        ? SizedBox()
                        : Expanded(
                            child: model.teams.length == 0
                                ? EmptyWidget(message: 'Không tìm thấy kết quả')
                                : ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        vertical: UIHelper.padding),
                                    itemCount: model.teams.length,
                                    separatorBuilder: (c, index) =>
                                        UIHelper.verticalIndicator,
                                    itemBuilder: (c, index) => _buildItemTeam(
                                      context,
                                      model.teams[index],
                                      onSubmitRequest: (teamId, content,
                                              position) =>
                                          _handleCreateRequest(
                                              teamId, content, position, model),
                                    ),
                                  ),
                          ),
                    child
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
