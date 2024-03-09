import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trivago/converter/date_time_range_converter.dart';
import 'package:trivago/core/snack_bar.dart';
import 'package:trivago/features/booking/controller/booking_controller.dart';
import 'package:trivago/features/booking/repository/booking_repository.dart';
import 'package:trivago/features/booking/widget/book_button.dart';
import 'package:trivago/features/home/widget/district_area.dart';
import 'package:trivago/models/booked_models/booked_models.dart';
import 'package:trivago/models/room_models/room_model.dart';

class DistrictTiles extends ConsumerStatefulWidget {
  const DistrictTiles(
      {super.key,
      required this.roomModel,
      required this.roomList,
      required this.selectedRoomList});
  final RoomModel roomModel;
  final void Function(String) roomList;
  final List<String> selectedRoomList;
  @override
  ConsumerState createState() => _DistrictTilesState();
}

class _DistrictTilesState extends ConsumerState<DistrictTiles> {
  static final formKey = GlobalKey<FormState>();

  bool selected = false;
  @override
  Widget build(
    BuildContext context,
  ) {
    ref.watch(bookingControllerProvider);

    final bookings = ref.watch(bookingsProvider).valueOrNull ?? <BookingData>[];

    final booking = bookings.firstWhereOrNull(
      (element) {
        return element.roomName == widget.roomModel.name &&
            element.districtID == widget.roomModel.district &&
            ref.read(bookingControllerProvider).selectedDate.isBetween(
                element.vacantDuration.start, element.vacantDuration.end);
      },
    );
    BookingController bookingController = BookingController();
    final availableRoom = bookingController.roomCalculator(
        ref.watch(bookingControllerProvider).selectedDate,
        ref,
        widget.roomModel.district);

    void show(data) {
      showSnackBar(context, data);
    }

    TextEditingController priceController = TextEditingController();
    void updateCalculatedPrice() {
      priceController.text = bookingController.calculatingLogic(ref).toString();
      ref
          .read(bookingControllerProvider.notifier)
          .setTotalPrice(bookingController.calculatingLogic(ref));
    }

    Color colorDetermine() {
      if (availableRoom == 0) {
        return Colors.red.withOpacity(0.7);
      } else {
        return booking != null
            ? Colors.red.withOpacity(0.7)
            : Colors.green.withOpacity(0.7);
      }
      return booking != null
          ? Colors.red.withOpacity(0.7)
          : Colors.green.withOpacity(0.7);
    }

    if (widget.selectedRoomList.contains(widget.roomModel.name) &&
        booking == null) {
      selected = true;
    } else {
      selected = false;
    }
    if (booking != null) {
      selected = false;
    }
    if (availableRoom == 0) {
      selected = false;
    }
    return InkWell(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadiusDirectional.all(
              Radius.circular(10),
            ),
            color: selected ? Colors.grey.withOpacity(0.5) : Colors.transparent,
          ),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(2),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 80),
              decoration: BoxDecoration(
                  color: colorDetermine(),
                  borderRadius:
                      const BorderRadiusDirectional.all(Radius.circular(10))),
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.roomModel.name,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8)),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          if (booking == null && availableRoom != 0) {
            selected = !selected;
            print(selected);
            widget.roomList(widget.roomModel.name);
          }
        });
      },
      onDoubleTap: () {
        if (booking != null || selectedRoomList.length > availableRoom) {
          print('No');
          return;
        }
        !selected
            ? null
            : showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Center(
                      child: Text(
                        widget.roomModel.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    insetPadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    content: Builder(
                      builder: (context) {
                        final homeFunction =
                            ref.read(bookingControllerProvider.notifier);
                        // Get available height and width of the build area of this widget. Make a choice depending on the size.
                        var height = MediaQuery.of(context).size.height;
                        var width = MediaQuery.of(context).size.width;
                        return Container(
                          padding: EdgeInsets.zero,
                          width: width * 0.8,
                          height: height * 0.8,
                          child: Form(
                            key: formKey,
                            child: ListView(
                              children: [
                                Column(
                                  children: [
                                    SfDateRangePicker(
                                      initialDisplayDate: ref
                                          .read(bookingControllerProvider)
                                          .selectedDate,
                                      enablePastDates: false,
                                      headerStyle:
                                          const DateRangePickerHeaderStyle(
                                              textAlign: TextAlign.start),
                                      monthCellStyle:
                                          DateRangePickerMonthCellStyle(
                                        blackoutDateTextStyle: TextStyle(
                                          color:
                                              Colors.redAccent.withOpacity(0.4),
                                        ),
                                        cellDecoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          border:
                                              Border.all(color: Colors.white24),
                                        ),
                                      ),
                                      monthViewSettings:
                                          DateRangePickerMonthViewSettings(
                                        blackoutDates:
                                            bookingController.blackOutDates(
                                          ref,
                                          widget.roomModel.district,
                                          selectedRoomList,
                                        ),
                                      ),
                                      view: DateRangePickerView.month,
                                      onSelectionChanged: (d) {
                                        final value = d.value;
                                        if (value is PickerDateRange) {
                                          if (value.endDate != null) {
                                            homeFunction.setDateRange(
                                                DateTimeRange(
                                                    start: value.startDate!,
                                                    end: value.endDate!));
                                            updateCalculatedPrice();
                                          } else {
                                            homeFunction.setDateRange(
                                                DateTimeRange(
                                                    start: value.startDate!,
                                                    end: value.startDate!));
                                            updateCalculatedPrice();
                                          }
                                        } else {
                                          if (value is DateTimeRange) {
                                            homeFunction
                                                .setSelectedDate(value.start);
                                            updateCalculatedPrice();
                                          }
                                        }
                                      },
                                      selectionMode:
                                          DateRangePickerSelectionMode.range,
                                    ),
                                    // const BookedList(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          final raw = value ?? '';
                                          if (raw.isEmpty) {
                                            return 'Field cannot be empty';
                                          }
                                          return null;
                                        },
                                        onChanged: ref
                                            .read(bookingControllerProvider
                                                .notifier)
                                            .setCustomerName,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(),
                                          labelText: 'Name',
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      onChanged: (txt) {
                                        final data = int.tryParse(txt);
                                        if (data == null) return;
                                        homeFunction.setPhoneNumber(data);
                                      },
                                      validator: (value) {
                                        final raw = value ?? '';
                                        if (raw.isEmpty) {
                                          return 'Field cannot be empty';
                                        }
                                        final data = int.tryParse(raw);

                                        if (data == null) {
                                          return 'Must contain only Numbers!';
                                        }
                                        return null;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: const [],
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(5),
                                        border: OutlineInputBorder(),
                                        labelText: 'Phone Number',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: TextFormField(
                                        onChanged: (txt) {
                                          if (txt.isNotEmpty) {
                                            final data = int.tryParse(txt);
                                            if (data == '') {
                                              return;
                                            }
                                            if (data == null) return;
                                            homeFunction.setPersonCount(data);
                                            updateCalculatedPrice();
                                          }
                                        },
                                        validator: (value) {
                                          final raw = value ?? '';
                                          if (raw.isEmpty) {
                                            return 'Field cannot be empty';
                                          }
                                          final data = int.tryParse(raw);
                                          if (data == null) {
                                            return 'Must contain only Numbers!';
                                          }

                                          return null;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: const [],
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(),
                                          labelText: 'People',
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: priceController,
                                      onChanged: (txt) {
                                        if (txt.isNotEmpty) {
                                          final data = int.tryParse(txt);
                                          if (data == null) return;
                                          homeFunction.setTotalPrice(data);
                                        }
                                      },
                                      validator: (value) {
                                        final raw = value ?? '';
                                        if (raw.isEmpty) {
                                          return 'Field cannot be empty';
                                        }
                                        final data = int.tryParse(raw);
                                        if (data == null) {
                                          return 'Must contain only Numbers!';
                                        }

                                        return null;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: const [],
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(5),
                                        border: OutlineInputBorder(),
                                        labelText: 'Price',
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.15,
                                    ),
                                    BookButton(
                                      selectedRooms: selectedRoomList,
                                      blackoutDates:
                                          bookingController.blackOutDates(
                                        ref,
                                        widget.roomModel.district,
                                        selectedRoomList,
                                      ),
                                      parentContext: context,
                                      name: widget.roomModel.name,
                                      districtID: widget.roomModel.district,
                                      availableRoom: availableRoom,
                                      formKey: formKey,
                                      errorCall: (data) {
                                        show(data);
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                });
      },
    );
  }
}
