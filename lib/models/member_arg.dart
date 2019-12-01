import 'package:myfootball/models/member.dart';

class MemberArgument {
  Member member;
  bool showFull;

  MemberArgument({this.member, this.showFull = true});
}