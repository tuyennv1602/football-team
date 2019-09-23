import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/search-widget.dart';
import 'package:myfootball/ui/widgets/image-widget.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/viewmodels/request_member_view_model.dart';
import 'package:provider/provider.dart';

class RequestMemberPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Widget _buildItemTeam(BuildContext context, Team team) => InkWell(
        onTap: () => _showRequestForm(context, team),
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ImageWidget(
                source: team.logo,
                placeHolder: Images.DEFAULT_LOGO,
              ),
              UIHelper.horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            team.name,
                            style: textStyleSemiBold(color: BLACK_TEXT),
                          ),
                        ),
                        FlutterRatingBarIndicator(
                          rating: 2.5,
                          itemCount: 5,
                          itemPadding: EdgeInsets.only(left: 2),
                          itemSize: UIHelper.size(12),
                          emptyColor: Colors.amber.withAlpha(90),
                        )
                      ],
                    ),
                    Text(
                      team.bio,
                      style: textStyleRegular(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Trình độ: Trung bình',
                          style: textStyleRegular(),
                        ),
                        Text(
                          '${team.countMember} thành viên',
                          style: textStyleRegular(),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  void _showRequestForm(BuildContext context, Team team) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIHelper.size5),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(UIHelper.size10),
                child: Column(
                  children: <Widget>[
                    Text(
                      team.name,
                      style: textStyleSemiBold(size: 18),
                    ),
//                      Form(
//                        key: _formKey,
//                        child: InputWidget(
//                          validator: (value) {
//                            if (value.isEmpty)
//                              return StringRes.REQUIRED_CONTENT;
//                            return null;
//                          },
//                          maxLines: 5,
//                          maxLength: 150,
//                          inputType: TextInputType.text,
//                          inputAction: TextInputAction.done,
//                          labelText: StringRes.CONTENT,
//                          onChangedText: (text) =>
//                              pageBloc.changeContentFunc(text),
//                        ),
//                      )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonWidget(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(UIHelper.size5)),
                      backgroundColor: Colors.grey,
                      height: UIHelper.size40,
                      child: Text(
                        StringRes.CANCEL,
                        style: textStyleButton(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ButtonWidget(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.of(context).pop();
                        }
                      },
                      height: UIHelper.size40,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(UIHelper.size5)),
                      backgroundColor: PRIMARY,
                      child: Text(
                        StringRes.SEND_REQUEST,
                        style: textStyleButton(),
                      ),
                    ),
                  )
                ],
              )
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
              'Tìm kiếm đội bóng',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.STACK,
              onTap: () => Routes.routeToUserRequest(context),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<RequestMemberViewModel>(
                model: RequestMemberViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.searchTeamByKey(''),
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
                                    padding: EdgeInsets.zero,
                                    itemCount: model.teams.length,
                                    separatorBuilder: (c, index) =>
                                        LineWidget(),
                                    itemBuilder: (c, index) => _buildItemTeam(
                                        context, model.teams[index]),
                                  ),
                          ),
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
