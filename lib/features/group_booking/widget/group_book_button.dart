import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trivago/core/failure.dart';
import 'package:trivago/features/booking/controller/booking_controller.dart';
import 'package:trivago/features/group_booking/controller/group_booking_controller.dart';
import 'package:trivago/features/group_booking/repository/group_booking_repository.dart';
import 'package:trivago/features/state/state.dart';
import 'package:trivago/models/room_models/room_model_data.dart';

class GroupBookButton extends ConsumerStatefulWidget {
  const GroupBookButton({
    super.key,
    required this.errorCall,
    required this.formKey2,
  });
  final void Function(String) errorCall;
  final GlobalKey<FormState> formKey2;

  @override
  ConsumerState createState() => _GroupBookButtonState();
}

class _GroupBookButtonState extends ConsumerState<GroupBookButton> {
  Either bookRoom(HomeState state, WidgetRef ref) {
    try {
      return right(ref
          .read(groupBookingRepositoryProvider)
          .bookRoom(context, state, (data) {
        widget.errorCall(data);
      }, ref));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    GroupBookingController groupBookingController = GroupBookingController();

    final availableRoom = groupBookingController.roomCalculator(
        ref.watch(bookingControllerProvider).districtID ?? DistrictsID.A, ref);

    return OutlinedButton(
        onPressed: () {
          final valid = widget.formKey2.currentState?.validate() ?? false;

          if (!valid) return;

          // if (ref.read(bookingControllerProvider).roomBooked! <=
          //     availableRoom) {
          //   bookRoom(ref.read(bookingControllerProvider), ref);
          //   Navigator.pop(context);
          // }
          bookRoom(ref.read(bookingControllerProvider), ref);
          Navigator.pop(context);
        },
        child: const Text('Book'));
  }
}
