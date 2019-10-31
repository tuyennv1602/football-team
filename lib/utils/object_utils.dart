import 'package:myfootball/models/invite_request.dart';
import 'package:myfootball/models/matching_time_slot.dart';
import 'package:queries/collections.dart';
import 'package:queries/queries.dart';

class ObjectUtil {
  static Map<int, List<MatchingTimeSlot>> mapMatchingTimeSlotByDayOfWeek(
      List<MatchingTimeSlot> timeSlots) {
    return _mapCollectionToIntMap(Collection<MatchingTimeSlot>(timeSlots)
        .groupBy((item) => item.dayOfWeek));
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

  static _mapCollectionToStringMap<T>(IEnumerable<IGrouping<String, T>> item) {
    var result = <String, List<T>>{};
    for (var group in item.asIterable()) {
      result[group.key] = <T>[];
      for (var child in group.asIterable()) {
        result[group.key].add(child);
      }
    }
    return result;
  }
}
