import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui_helper.dart';

class RankingPage extends StatelessWidget {


  Widget _buildItemTeam() => Padding(
    padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
    child: Row(
          children: <Widget>[
            SizedBox(
              width: UIHelper.size50,
              child: Text(
                '1',
                style: textStyleRegularTitle(size: 15),
              ),
            ),
            Expanded(
              child: Text(
                'Acazia FC',
                style: textStyleRegularTitle(size: 15),
              ),
            ),
            SizedBox(
              width: UIHelper.size50,
              child: Text(
                '90',
                style: textStyleRegularTitle(size: 15),
              ),
            ),
            SizedBox(
              width: UIHelper.size50,
              child: Text(
                '45',
                style: textStyleRegularTitle(size: 15),
              ),
            ),
            SizedBox(
              width: UIHelper.size(70),
              child: Text(
                '1002.56',
                style: textStyleRegularTitle(size: 15),
              ),
            )
          ],
        ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            centerContent: Text('Bảng xếp hạng',
                textAlign: TextAlign.center, style: textStyleTitle()),
          ),
          Expanded(
            child: BorderBackground(
              child: Padding(
                padding: EdgeInsets.all(UIHelper.size10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: UIHelper.size50,
                          child: Text(
                            'Hạng',
                            style: textStyleSemiBold(size: 15),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Đội bóng',
                            style: textStyleSemiBold(size: 15),
                          ),
                        ),
                        SizedBox(
                          width: UIHelper.size50,
                          child: Text(
                            'MP',
                            style: textStyleSemiBold(size: 15),
                          ),
                        ),
                        SizedBox(
                          width: UIHelper.size50,
                          child: Text(
                            'W',
                            style: textStyleSemiBold(size: 15),
                          ),
                        ),
                        SizedBox(
                          width: UIHelper.size(70),
                          child: Text(
                            'P',
                            style: textStyleSemiBold(size: 15),
                          ),
                        )
                      ],
                    ),
                    UIHelper.verticalSpaceMedium,
                    LineWidget(indent: 0),
                    UIHelper.verticalSpaceSmall,
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          _buildItemTeam(),
                          _buildItemTeam(),
                          _buildItemTeam(),
                          _buildItemTeam()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
