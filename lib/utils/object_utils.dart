import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/matching_time_slot.dart';
import 'package:queries/collections.dart';
import 'package:queries/queries.dart';

class ObjectUtil {
  static Map<int, List<MatchingTimeSlot>> mapMatchingTimeSlotByDayOfWeek(
      List<MatchingTimeSlot> timeSlots) {
    return _mapCollectionToIntMap(Collection<MatchingTimeSlot>(timeSlots)
        .groupBy((item) => item.dayOfWeek));
  }

  static Map<int, List<MatchingTimeSlot>> mapMatchingTimeSlotByPlayDate(
      List<MatchingTimeSlot> timeSlots) {
    return _mapCollectionToIntMap(Collection<MatchingTimeSlot>(timeSlots)
        .groupBy((item) => item.playDate));
  }

  static Map<int, List<InviteRequest>> mapInviteRequestById(
      List<InviteRequest> invites) {
    return _mapCollectionToIntMap(Collection<InviteRequest>(invites)
        .groupBy((item) => item.getTypeRequest));
  }

  static _mapCollectionToIntMap<T>(IEnumerable<IGrouping<int, T>> item) {
    var result = <int, List<T>>{};
    for (var group in item.asIterable()) {
      result[group.key] = <T>[];
      for (var child in group.asIterable()) {
        result[group.key].add(child);
      }
    }
    return result;
  }
  

}
