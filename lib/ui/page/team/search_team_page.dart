import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/bottom_sheet.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/input_text_widget.dart';
import 'package:myfootball/ui/widget/multichoice_position.dart';
import 'package:myfootball/ui/widget/search_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/search_team_viewmodel.dart';
import 'package:provider/provider.dart';

enum SEARCH_TYPE {
  REQUEST_MEMBER,
  COMPARE_TEAM,
  SELECT_OPPONENT_TEAM,
  TEAM_DETAIL
}

// ignore: must_be_immutable
class SearchTeamPage extends StatelessWidget {
  String _content;
  List<String> _positions;
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

  Widget _buildItemTeam(BuildContext context, Team team,
          {Function onSubmitRequest}) =>
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.padding),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
        child: InkWell(
          onTap: () {
            if (type == SEARCH_TYPE.COMPARE_TEAM) {
              NavigationService.instance
                  .navigateTo(COMPARE_TEAM, arguments: team);
            } else if (type == SEARCH_TYPE.REQUEST_MEMBER) {
              _positions = null;
              _showOptions(
                context,
                onDetail: () => NavigationService.instance
                    .navigateTo(TEAM_DETAIL, arguments: team),
                onRequest: () =>
                    _showRequestForm(context, team, onSubmit: onSubmitRequest),
              );
            } else if (type == SEARCH_TYPE.TEAM_DETAIL) {
              NavigationService.instance
                  .navigateTo(TEAM_DETAIL, arguments: team);
            } else {
              Navigator.of(context).pop(team);
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(UIHelper.padding),
                child: Hero(
                  tag: team.id,
                  child: ImageWidget(
                    source: team.logo,
                    placeHolder: Images.DEFAULT_LOGO,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      0, UIHelper.padding, UIHelper.padding, UIHelper.padding),
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
                      UIHelper.verticalSpaceSmall,
                      Text(
                        team.bio,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: textStyleRegularBody(color: Colors.black54),
                      ),
                      UIHelper.verticalSpaceSmall,
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
                                  padding:
                                      EdgeInsets.only(left: UIHelper.size5),
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
                                  padding:
                                      EdgeInsets.only(left: UIHelper.size5),
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
                                  padding:
                                      EdgeInsets.only(left: UIHelper.size5),
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

  _showRequestForm(BuildContext context, Team team, {Function onSubmit}) =>
      UIHelper.showCustomizeDialog(
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
            UIHelper.verticalSpaceSmall,
            Text(
              'Vị trí có thể chơi (Chọn 1 hoặc nhiều)',
              style: textStyleRegularBody(color: Colors.white),
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
              NavigationService.instance.goBack();
              onSubmit(team.id);
            }
          }
        },
      );

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
              onTap: () => NavigationService.instance.goBack(),
            ),
            rightContent: type == SEARCH_TYPE.REQUEST_MEMBER
                ? AppBarButtonWidget(
                    imageName: Images.STACK,
                    onTap: () =>
                        NavigationService.instance.navigateTo(USER_REQUESTS))
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
                                    padding: EdgeInsets.only(
                                        bottom: UIHelper.padding),
                                    itemCount: model.teams.length,
                                    separatorBuilder: (c, index) =>
                                        UIHelper.verticalIndicator,
                                    itemBuilder: (c, index) => _buildItemTeam(
                                      context,
                                      model.teams[index],
                                      onSubmitRequest: (teamId) =>
                                          model.createRequest(
                                              teamId, _content, _positions),
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
