import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trivago/converter/date_time_range_converter.dart';
import 'package:trivago/core/failure.dart';
import 'package:trivago/features/booking/controller/booking_controller.dart';
import 'package:trivago/features/booking/repository/booking_repository.dart';
import 'package:trivago/features/home/widget/district_area.dart';
import 'package:trivago/features/state/state.dart';
import 'package:trivago/models/booked_models/booked_models.dart';
import 'package:trivago/models/room_models/room_model_data.dart';

class BookButton extends ConsumerStatefulWidget {
  const BookButton(
      {required this.parentContext,
      required this.blackoutDates,
      required this.selectedRooms,
      required this.availableRoom,
      required this.name,
      required this.districtID,
      required this.errorCall,
      required this.formKey,
      super.key});
  final String name;
  final List<String> selectedRooms;
  final BuildContext parentContext;
  final DistrictsID districtID;
  final int availableRoom;
  final List<DateTime> blackoutDates;
  final void Function(String) errorCall;
  final GlobalKey<FormState> formKey;

  @override
  ConsumerState createState() => _BookButtonState();
}

class _BookButtonState extends ConsumerState<BookButton> {
  bookRoom(
    HomeState state,
  ) {
    try {
      print('DOG');
      print(selectedRoomList);

      List<Either<Failure, dynamic>> results = [];

      for (String room in selectedRoomList) {
        print(room);
        results.add(
          right(
            ref.read(bookingRepositoryProvider).bookRoom(
              BookingData(
                id: FirebaseFirestore.instance.collection('dog').doc().id,
                districtID: state.districtID!,
                vacantDuration: state.timeRange!,
                customerName: state.customerName!,
                totalPrice: state.totalPrice!,
                personCount: state.personCount!,
                phoneNumber: state.phoneNumber!,
                byCash: state.byCash!,
                roomName: room,
                hasBreakfastService: state.hasBreakfast!,
                unknownBool1: state.unknownBool1!,
                unknownBool2: state.unknownBool2!,
                unknownBool3: state.unknownBool3!,
              ),
              (data) {
                widget.errorCall(data);
              },
              ref,
            ),
          ),
        );
      }
      selectedRoomList.clear();
      return results; // Return the list of results after the loop completes
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      if (e.toString().contains('Null check operator used on a null value')) {
        widget.errorCall('Booking Failed! Fill in all the Data.');
      } else {
        widget.errorCall(e.toString());
      }
      return [
        left(Failure(e.toString()))
      ]; // Return a failure if an error occurs
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final homeFunction = ref.read(bookingControllerProvider.notifier);
    return OutlinedButton(
        onPressed: () {
          try {
            final valid = widget.formKey.currentState?.validate() ?? false;
            if (!valid) return;
            final List<bool> bookedDates = [];
            for (DateTime data in widget.blackoutDates) {
              if (data.isBetween(
                  ref.watch(bookingControllerProvider).timeRange!.start,
                  ref.watch(bookingControllerProvider).timeRange!.end)) {
                bookedDates.add(false);
              } else {
                bookedDates.add(true);
              }
            }
            homeFunction.setRoomName(widget.name);
            homeFunction.setDistrictID(widget.districtID);
            if (!bookedDates.contains(false) && widget.availableRoom > 0) {
              bookRoom(
                ref.read(bookingControllerProvider),
              );
              Navigator.pop(context);
            }
          } on FirebaseException catch (e) {
            throw e.message!;
          } catch (e) {
            Navigator.pop(context);
            if (e
                .toString()
                .contains('Null check operator used on a null value')) {
              widget.errorCall('Booking Failed! Fill in all the Data.');
            } else {
              widget.errorCall(e.toString());
            }
          }
        },
        child: const Text('Book'));
  }
}
