import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trivago/models/room_models/room_model_data.dart';
import '../../converter/date_time_range_converter.dart';

part 'booked_models.freezed.dart';
part 'booked_models.g.dart';

@freezed
class BookingData with _$BookingData {
  const BookingData._();

  @JsonSerializable(explicitToJson: true)
  const factory BookingData({
    @DateTimeRangeConverter() required DateTimeRange vacantDuration,
    required String customerName,
    required int totalPrice,
    required String id,
    required int personCount,
    required int phoneNumber,
    required bool byCash,
    required DistrictsID districtID,
    required String roomName,
    required bool hasBreakfastService,
    required bool unknownBool1,
    required bool unknownBool2,
    required bool unknownBool3,
  }) = _BookingData;

  factory BookingData.fromJson(Map<String, dynamic> json) =>
      _$BookingDataFromJson(json);

  bool isBooked(DateTime time) =>
      time.isBetween(vacantDuration.start, vacantDuration.end);
  // time.isAtSameMomentAs(vacantDuration.end) ||
  // time.isAtSameMomentAs(vacantDuration.start);
  bool doDateTimeRangesOverlap(DateTime selectedStart, DateTime selectedEnd,
      DateTime roomStart, DateTime roomEnd) {
    return (selectedStart.dateOnly.isBefore(roomEnd.dateOnly) ||
            selectedStart.dateOnly.isAtSameMomentAs(roomEnd.dateOnly)) &&
        (selectedEnd.dateOnly.isAfter(roomStart.dateOnly) ||
            selectedEnd.dateOnly.isAtSameMomentAs(roomStart.dateOnly));
  }
}

@freezed
class GroupBookingData with _$GroupBookingData {
  const GroupBookingData._();

  @JsonSerializable(explicitToJson: true)
  const factory GroupBookingData({
    @DateTimeRangeConverter() required DateTimeRange vacantDuration,
    required String customerName,
    required String id,
    required int totalPrice,
    required int personCount,
    required int phoneNumber,
    required bool byCash,
    required int roomBooked,
    required DistrictsID districtID,
    required bool hasBreakfastService,
    required bool unknownBool1,
    required bool unknownBool2,
    required bool unknownBool3,
  }) = _GroupBookingData;

  factory GroupBookingData.fromJson(Map<String, dynamic> json) =>
      _$GroupBookingDataFromJson(json);

  bool isBooked(DateTime time) =>
      time.isBetween(vacantDuration.start, vacantDuration.end);
  bool doDateTimeRangesOverlap(DateTime selectedStart, DateTime selectedEnd,
      DateTime roomStart, DateTime roomEnd) {
    return (selectedStart.dateOnly.isBefore(roomEnd.dateOnly) ||
            selectedStart.isAtSameMomentAs(roomEnd.dateOnly)) &&
        (selectedEnd.dateOnly.isAfter(roomStart.dateOnly) ||
            selectedEnd.dateOnly.isAtSameMomentAs(roomStart.dateOnly));
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
}
