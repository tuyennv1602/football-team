import 'package:flutter/cupertino.dart';
import 'package:myfootball/res/images.dart';

class TeamAvatarWidget extends StatelessWidget {
  final String source;
  final double size;
  TeamAvatarWidget({@required this.source, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return source != null
        ? FadeInImage.assetNetwork(
            image: source,
            placeholder: Images.DEFAULT_LOGO,
            width: size,
            height: size,
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
            fadeOutDuration: Duration(milliseconds: 100),
          )
        : Image.asset(
            Images.DEFAULT_LOGO,
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
  }
}
