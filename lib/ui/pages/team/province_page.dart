import 'package:flutter/material.dart';
import 'package:myfootball/models/province.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/viewmodels/province_viewmodel.dart';

class ProvincePage extends StatelessWidget {
  Widget _buildItemProvince(
          BuildContext context, Province province, Function onTap) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: UIHelper.size15, horizontal: UIHelper.size20),
          child: Text(
            province.name,
            style: textStyleRegularTitle(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Chọn tỉnh thành',
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
              child: BaseWidget<ProvinceViewModel>(
                model: ProvinceViewModel(),
                onModelReady: (mode) => mode.getProvinces(),
                builder: (c, model, child) {
                  if (model.busy) {
                    return LoadingWidget();
                  }
                  return model.provinces.length > 0
                      ? ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (c, index) => _buildItemProvince(
                              context, model.provinces[index], () {}),
                          separatorBuilder: (c, index) => LineWidget(),
                          itemCount: model.provinces.length)
                      : EmptyWidget(message: 'Không tìm thấy tỉnh/thành nào');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
