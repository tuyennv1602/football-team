import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/item_comment.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/team_comment_viewmodel.dart';
import 'package:provider/provider.dart';

class TeamCommentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Đánh giá & nhận xét',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<TeamCommentViewModel>(
                model: TeamCommentViewModel(api: Provider.of(context)),
                onModelReady: (model) =>
                    model.getComments(Provider.of<Team>(context).id),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.comments.length == 0
                        ? EmptyWidget(message: 'Chưa có nhận xét & đánh giá')
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                                vertical: UIHelper.padding),
                            itemBuilder: (c, index) =>
                                ItemComment(comment: model.comments[index]),
                            separatorBuilder: (c, index) => LineWidget(),
                            itemCount: model.comments.length),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
