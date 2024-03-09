import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trivago/converter/date_time_range_converter.dart';
import 'package:trivago/features/booking/repository/booking_repository.dart';
import 'package:trivago/features/group_booking/repository/group_booking_repository.dart';

import 'package:trivago/features/state/state.dart';
import 'package:trivago/models/booked_models/booked_models.dart';
import 'package:trivago/models/room_models/room_model_data.dart';

part 'booking_controller.g.dart';

@riverpod
class BookingController extends _$BookingController {
  @override
  HomeState build() => HomeState(
      selectedDate: DateTime.now(),
      roomBooked: 1,
      unknownBool1: false,
      unknownBool2: false,
      unknownBool3: false,
      byCash: false,
      hasBreakfast: false,
      districtID: DistrictsID.A);

  clearState(WidgetRef ref) {
    state = HomeState(
        selectedDate: ref.watch(bookingControllerProvider).selectedDate,
        roomBooked: 1,
        unknownBool1: false,
        unknownBool2: false,
        unknownBool3: false,
        byCash: false,
        hasBreakfast: false,
        districtID: DistrictsID.A);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setCustomerName(String name) {
    state = state.copyWith(customerName: name);
  }

  // void setTotalModifier(int changes) {
  //   state = state.copyWith(totalPrice: changes);
  // }
  void setDistrictID(DistrictsID id) => state = state.copyWith(districtID: id);

  void setTotalPrice(int total) => state = state.copyWith(totalPrice: total);
  void setPersonCount(int count) => state = state.copyWith(personCount: count);
  void byCash(bool byCash) => state = state.copyWith(byCash: byCash);
  void hasBreakfast(bool hasBreakfast) =>
      state = state.copyWith(hasBreakfast: hasBreakfast);
  // void hasEntranceFee(bool hasEntranceFee) =>
  //     state = state.copyWith(hasEntranceFee: hasEntranceFee);
  // void setRoomID(String id) => state = state.copyWith(roomID: id);
  void setRoomName(String name) => state = state.copyWith(roomName: name);
  void setUKBool1(bool bool) => state = state.copyWith(unknownBool1: bool);
  void setUKBool2(bool bool) => state = state.copyWith(unknownBool2: bool);
  void setUKBool3(bool bool) => state = state.copyWith(unknownBool3: bool);
  void setPhoneNumber(int number) =>
      state = state.copyWith(phoneNumber: number);
  void setDateRange(DateTimeRange range) =>
      state = state.copyWith(timeRange: range);
  void setRoomBooked(int room) => state = state.copyWith(roomBooked: room);

  int roomCalculator(
      DateTime selectedDate, WidgetRef ref, DistrictsID district) {
    ref.watch(bookingControllerProvider);
    final bookings = ref.watch(bookingsProvider).valueOrNull ?? <BookingData>[];
    final groupBookings =
        ref.watch(groupBookingsProvider).valueOrNull ?? <GroupBookingData>[];

    final groupRoomBooked = groupBookings.where((element) {
      return element.isBooked(selectedDate) && element.districtID == district;
    });

    final booked = bookings.where((element) {
      return element.isBooked(selectedDate) && element.districtID == district;
    });

    int groupBookedSum = 0;
    final int roomUnbooked = roomData[district]?.length ?? -9999;
    for (var element in groupRoomBooked) {
      int total = element.roomBooked;
      groupBookedSum += total;
    }
    return (roomUnbooked - booked.length - groupBookedSum);
  }

  List<DateTime> blackOutDates(
      WidgetRef ref, DistrictsID id, List<String> roomNameList) {
    ref.watch(bookingControllerProvider);
    List<DateTime> dateBooked = [];
    for (String rooms in roomNameList) {
      final bookings =
          ref.watch(bookingsProvider).valueOrNull ?? <BookingData>[];
      final roomBooked = bookings.where((element) {
        return element.districtID == id && element.roomName == rooms;
      });

      for (var element in roomBooked) {
        dateBooked.addAll(getDaysInBetweenIncludingStartEndDate(
            startDateTime: element.vacantDuration.start,
            endDateTime: element.vacantDuration.end));
      }
    }
    return dateBooked;
  }

  List<DateTime> getDaysInBetweenIncludingStartEndDate(
      {required DateTime startDateTime, required DateTime endDateTime}) {
    // Converting dates provided to UTC
    // So that all things like DST don't affect subtraction and addition on dates
    DateTime startDateInUTC = DateTime.utc(
        startDateTime.year, startDateTime.month, startDateTime.day);
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

  int calculatingLogic(WidgetRef ref) {
    final home = ref.watch(bookingControllerProvider);
    final List<DateTime> specialDates1 = [
      DateTime(2024, 4, 5),
      DateTime(2024, 4, 6),
      DateTime(2024, 4, 7),
      DateTime(2024, 4, 8)
    ]; //华⼈年
    final List<DateTime> specialDates2 = []; //⻢来年
    int specialDaysCount1 = 0;
    int specialDaysCount2 = 0;
    if (home.timeRange != null) {
      for (DateTime date = home.timeRange!.start;
          date.isBeforeOrEqualTo(home.timeRange!.end);
          date = date.add(
        const Duration(days: 1),
      ),) {
        if (specialDates1.contains(date)) {
          specialDaysCount1++;
        }
      }
    }

    return (roomData[home.districtID]!.first.defaultPrice *
            home.roomBooked! *
            ((home.timeRange?.duration.inDays ?? 1) + 1) +
        50 * (home.personCount ?? 1) +
        300 * specialDaysCount1 +
        300 * specialDaysCount2);
  }
}
