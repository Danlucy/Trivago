import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/features/analytics/screen/operational_analytics_screen.dart';
import 'package:trivago/features/booking/repository/booking_repository.dart';
import 'package:trivago/features/group_booking/repository/group_booking_repository.dart';
import 'package:trivago/models/booked_models/booked_models.dart';

class AnalyticsController {
  getWeeklyBookings(WidgetRef ref, DateTime dateTime) {
    final test = DateTime.utc(DateTime.friday);
    final bookings = ref.watch(bookingsProvider).valueOrNull ?? <BookingData>[];
    final groupBookings =
        ref.watch(groupBookingsProvider).valueOrNull ?? <GroupBookingData>[];
    final listDays = <WeeklySalesData>[];
    print(test);

    for (int i = 0; i < 7; i++) {
      int groupBookedSum = 0;
      final groupRoomBooked = groupBookings.where((element) {
        return element.isBooked(
            DateTime.utc(dateTime.year, dateTime.month, dateTime.day + i));
      });

      for (var element in groupRoomBooked) {
        int total = element.roomBooked;
        groupBookedSum += total;
      }
      final booking = bookings.where((element) {
        return element.isBooked(
            DateTime.utc(dateTime.year, dateTime.month, dateTime.day + i));
      });
      final roomBookedPerDay = booking.length + groupBookedSum;
      print('${booking.length + groupBookedSum} ${dateTime.day + i} ');
      // map[dateTime.day + i] = roomBookedPerDay;
      listDays.add(WeeklySalesData(
          DateTime(dateTime.year, dateTime.month, dateTime.day + i),
          roomBookedPerDay));
    }
    return listDays;
  }
}

class WeeklySalesData {
  WeeklySalesData(this.days, this.sales);

  final DateTime days;
  final int sales;
}
