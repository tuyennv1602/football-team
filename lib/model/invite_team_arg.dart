import 'matching_time_slot.dart';

class InviteTeamArgument {
  int fromTeamId;
  int toTeamId;
  Map<int, List<MatchingTimeSlot>> mappedTimeSlots;

  InviteTeamArgument({this.fromTeamId, this.toTeamId, this.mappedTimeSlots});
}
