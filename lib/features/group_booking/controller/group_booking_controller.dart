import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/features/booking/controller/booking_controller.dart';
import 'package:trivago/features/booking/repository/booking_repository.dart';
import 'package:trivago/features/group_booking/repository/group_booking_repository.dart';
import 'package:trivago/models/booked_models/booked_models.dart';
import 'package:trivago/models/room_models/room_model.dart';
import 'package:trivago/models/room_models/room_model_data.dart';

class GroupBookingController {
  int roomCalculator(DistrictsID e, WidgetRef ref) {
    final int roomUnbooked = roomData[e]?.length ?? -9999;
    final bookings = ref.watch(bookingsProvider).valueOrNull ?? <BookingData>[];
    final groupBookings =
        ref.watch(groupBookingsProvider).valueOrNull ?? <GroupBookingData>[];
    final data = ref.watch(bookingControllerProvider).timeRange;
    final List<String> availableRoom = [];
    final List<DateTime> dates = getDaysInBetweenIncludingStartEndDate(
        startDateTime: data?.start ?? DateTime.now(),
        endDateTime: data?.end ?? DateTime.now());

    for (RoomModel room in roomData[e]!) {
      final booking = bookings.where((element) {
        return element.districtID == e &&
            element.doDateTimeRangesOverlap(
                data?.start ?? DateTime.now(),
                data?.end ?? DateTime.now(),
                element.vacantDuration.start,
                element.vacantDuration.end) &&
            element.roomName == room.name;
      });
      if (booking.isEmpty) {
        availableRoom.add(room.name);
      }
      // print('${booking.length} ${room.name}');
    }
    int modifier = 0;
    List<int> lowestFinal = [];
    for (DateTime date in dates) {
      final groupRoomBooked = groupBookings.where((element) {
        return element.isBooked(date) && element.districtID == e;
      });
      int groupBookedSum = 0;
      for (var element in groupRoomBooked) {
        int total = element.roomBooked;
        groupBookedSum += total;
      }
      final booking = bookings.where((element) {
        return element.districtID == e && element.isBooked(date);
      });

      int vacantRoom = roomUnbooked - booking.length;

      int buffer = vacantRoom - availableRoom.length;

      if (vacantRoom - availableRoom.length < groupBookedSum) {
        modifier = (groupBookedSum - buffer);
      } else {
        modifier = 0;
      }
      lowestFinal.add((availableRoom.length - modifier));
    }

    int totalSum = lowestFinal.min;

    return totalSum;
  }

  int calculatingLogic(WidgetRef ref) {
    return (roomData[ref.read(bookingControllerProvider).districtID]!
                .first
                .defaultPrice *
            ref.read(bookingControllerProvider).roomBooked! *
            ((ref.read(bookingControllerProvider).timeRange?.duration.inDays ??
                    1) +
                1) +
        50 * (ref.read(bookingControllerProvider).personCount ?? 1));
  }
}

List<DateTime> getDaysInBetweenIncludingStartEndDate(
    {required DateTime startDateTime, required DateTime endDateTime}) {
  // Converting dates provided to UTC
  // So that all things like DST don't affect subtraction and addition on dates
  DateTime startDateInUTC =
      DateTime.utc(startDateTime.year, startDateTime.month, startDateTime.day);
  DateTime endDateInUTC =
      DateTime.utc(endDateTime.year, endDateTime.month, endDateTime.day);

  // Created a list to hold all dates
  List<DateTime> daysInFormat = [];

  // Starting a loop with the initial value as the Start Date
  // With an increment of 1 day on each loop
  // With condition current value of loop is smaller than or same as end date
  for (DateTime i = startDateInUTC;
      i.isBefore(endDateInUTC) || i.isAtSameMomentAs(endDateInUTC);
      i = i.add(const Duration(days: 1))) {
    // Converting back UTC date to Local date if it was local before
    // Or keeping in UTC format if it was UTC

    if (startDateTime.isUtc) {
      daysInFormat.add(i);
    } else {
      daysInFormat.add(DateTime(i.year, i.month, i.day));
    }
  }
  return daysInFormat;
}
