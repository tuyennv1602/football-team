import 'package:flutter/cupertino.dart';
import 'package:myfootball/utils/ui_helper.dart';

class ImageWidget extends StatelessWidget {
  final String source;
  final double size;
  final double radius;
  final String placeHolder;
  final BoxFit boxFit;

  ImageWidget(
      {Key key,
      @required this.source,
      @required this.placeHolder,
      this.size,
      this.radius,
      this.boxFit = BoxFit.contain})
      : assert(placeHolder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return source != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? UIHelper.size(5)),
            child: FadeInImage.assetNetwork(
              image: source,
              placeholder: placeHolder,
              width: size ?? UIHelper.size(55),
              height: size ?? UIHelper.size(55),
              fit: boxFit,
              fadeInDuration: Duration(milliseconds: 100),
              fadeOutDuration: Duration(milliseconds: 100),
            ),
          )
        : Image.asset(
            placeHolder,
            width: size ?? UIHelper.size(55),
            height: size ?? UIHelper.size(55),
            fit: boxFit,
          );
  }
}
