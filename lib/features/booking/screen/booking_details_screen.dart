import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trivago/constants/colour.dart';
import 'package:trivago/features/booking/repository/booking_repository.dart';
import 'package:trivago/models/booked_models/booked_models.dart';

class DetailsDialog extends ConsumerStatefulWidget {
  const DetailsDialog({
    super.key,
    required this.bookingData,
  });
  final BookingData bookingData;

  @override
  ConsumerState createState() => __ShowDialogState();
}

class __ShowDialogState extends ConsumerState<DetailsDialog> {
  final List<String> selectedRoomList = [];

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(bookingsProvider).valueOrNull ?? <BookingData>[];
    //
    // final booking = bookings.where(
    //   (element) {
    //     return element.districtID == widget.bookingData.districtID &&
    //         element.doDateTimeRangesOverlap(
    //             widget.bookingData.vacantDuration.start,
    //             widget.bookingData.vacantDuration.end,
    //             element.vacantDuration.start,
    //             element.vacantDuration.end);
    //   },
    // );
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

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: Center(
        child: SizedBox(
          width: width * 0.8,
          child: Text(
            textAlign: TextAlign.center,
            widget.bookingData.customerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      content: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.zero,
          height: height * 0.8,
          width: width * 0.8,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6750a4).withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.all(2),
                    child: Center(
                        child: Text(
                      widget.bookingData.roomName,
                    )),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(Icons.house),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        color: Pallete.greyColor,
                      ),
                    ),
                    child: Text(
                      widget.bookingData.districtID.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Pallete.peachColor.withOpacity(0.6),
                  ),
                  child: SfDateRangePicker(
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      blackoutDatesDecoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.3)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      blackoutDateTextStyle: TextStyle(
                        color: Colors.green.withOpacity(0.6),
                      ),
                      cellDecoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(color: Colors.white24),
                      ),
                    ),
                    view: DateRangePickerView.month,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      blackoutDates: getDaysInBetweenIncludingStartEndDate(
                          startDateTime:
                              widget.bookingData.vacantDuration.start,
                          endDateTime: widget.bookingData.vacantDuration.end),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${widget.bookingData.customerName}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text('Person Count: ${widget.bookingData.personCount}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16)),
                    Text(
                      'Phone Number: ${widget.bookingData.phoneNumber}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      'Total Price: ${widget.bookingData.totalPrice}฿',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const Divider(),
                    if (widget.bookingData.byCash == true)
                      const Text(
                        '•By Cash',
                        style:
                            TextStyle(color: Pallete.greyColor, fontSize: 12),
                      ),
                    if (widget.bookingData.hasBreakfastService == true)
                      const Text(
                        '•Breakfast Available',
                        style:
                            TextStyle(color: Pallete.greyColor, fontSize: 12),
                      ),
                    if (widget.bookingData.unknownBool1 == true)
                      const Text(
                        '•村⺠，导游， 司机',
                        style:
                            TextStyle(color: Pallete.greyColor, fontSize: 12),
                      ),
                    if (widget.bookingData.unknownBool2 == true)
                      const Text(
                        '•股东',
                        style:
                            TextStyle(color: Pallete.greyColor, fontSize: 12),
                      ),
                    if (widget.bookingData.unknownBool3 == true)
                      const Text(
                        '•政府⼈员',
                        style:
                            TextStyle(color: Pallete.greyColor, fontSize: 12),
                      ),
                    Row(
                      children: [
                        DetailsButton(
                          function: () {
                            ref
                                .watch(bookingRepositoryProvider)
                                .deleteGroupBooking(widget.bookingData.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          button: 'Delete',
                          colour: Colors.red,
                          confirmTitle: 'Confirm Delete Booking?',
                          selectedRoomList: selectedRoomList,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class DetailsButton extends StatelessWidget {
  const DetailsButton({
    super.key,
    required this.button,
    required this.colour,
    required this.function,
    required this.confirmTitle,
    required this.selectedRoomList,
  });
  final String button;
  final Color colour;
  final String confirmTitle;
  final Function function;

  final List selectedRoomList;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(foregroundColor: colour),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: Container(
                    width: width * 3 / 4,
                    height: height * 1 / 4,
                    decoration: BoxDecoration(
                        color: Pallete.peachColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          confirmTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                function();
                              },
                              child: const Text(
                                'Confirm',
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: Text(
          button,
        ),
      ),
    );
  }
}
