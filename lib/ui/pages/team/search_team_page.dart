import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/input_text_widget.dart';
import 'package:myfootball/ui/widgets/light_input_text.dart';
import 'package:myfootball/ui/widgets/multichoice_position.dart';
import 'package:myfootball/ui/widgets/search_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/search_team_viewmodel.dart';
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
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.size10),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
        child: InkWell(
          onTap: () {
            if (type == SEARCH_TYPE.COMPARE_TEAM) {
              NavigationService.instance()
                  .navigateTo(COMPARE_TEAM, arguments: team);
            } else if (type == SEARCH_TYPE.REQUEST_MEMBER) {
              _positions = null;
              _showOptions(
                context,
                onDetail: () => NavigationService.instance()
                    .navigateTo(TEAM_DETAIL, arguments: team),
                onRequest: () =>
                    _showRequestForm(context, team, onSubmit: onSubmitRequest),
              );
            } else if (type == SEARCH_TYPE.TEAM_DETAIL) {
              NavigationService.instance()
                  .navigateTo(TEAM_DETAIL, arguments: team);
            } else {
              Navigator.of(context).pop(team);
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: UIHelper.size10, horizontal: UIHelper.size15),
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
                  padding: EdgeInsets.all(UIHelper.size10),
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
                        padding:
                            EdgeInsets.symmetric(vertical: UIHelper.size(2)),
                        child: Text(
                          'Xếp hạng: ${team.rank} (${team.point} điểm)',
                          style: textStyleRegular(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Đánh giá: ',
                            style: textStyleRegular(),
                          ),
                          RatingBarIndicator(
                            rating: team.rating,
                            itemCount: 5,
                            itemPadding: EdgeInsets.only(left: 2),
                            itemSize: UIHelper.size15,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: PRIMARY,
                            ),
                          ),
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
              style: textStyleRegular(color: Colors.white),
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
              NavigationService.instance().goBack();
              onSubmit(team.id);
            }
          }
        },
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
              'Tìm kiếm đội bóng',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance().goBack(),
            ),
            rightContent: type == SEARCH_TYPE.REQUEST_MEMBER
                ? AppBarButtonWidget(
                    imageName: Images.STACK,
                    onTap: () =>
                        NavigationService.instance().navigateTo(USER_REQUESTS))
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
                                        vertical: UIHelper.size10),
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
