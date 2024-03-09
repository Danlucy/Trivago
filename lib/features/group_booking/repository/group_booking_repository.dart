import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trivago/core/failure.dart';
import 'package:trivago/core/firebase_provider.dart';
import 'package:trivago/core/type_defs.dart';
import 'package:trivago/features/booking/repository/booking_repository.dart';
import 'package:trivago/features/state/state.dart';
import 'package:trivago/models/booked_models/booked_models.dart';

import '../../../constants/firebase_constants.dart';

part 'group_booking_repository.g.dart';

final groupBookingRepositoryProvider = Provider((ref) {
  return GroupBookingRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class GroupBookingRepository {
  final FirebaseFirestore _firestore;

  GroupBookingRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _groupBook =>
      _firestore.collection(FirebaseConstants.groupBookingCollection);
  FutureEither<GroupBookingData> bookRoom(BuildContext context, HomeState state,
      Function(String) call, WidgetRef ref) async {
    try {
      GroupBookingData groupBookingData;

      groupBookingData = GroupBookingData(
          id: FirebaseFirestore.instance.collection('dog').doc().id,
          districtID: state.districtID!,
          vacantDuration: state.timeRange!,
          customerName: state.customerName!,
          totalPrice: state.totalPrice!,
          personCount: state.personCount!,
          phoneNumber: state.phoneNumber!,
          byCash: state.byCash!,
          roomBooked: state.roomBooked!,
          hasBreakfastService: state.hasBreakfast!,
          unknownBool1: state.unknownBool1!,
          unknownBool2: state.unknownBool2!,
          unknownBool3: state.unknownBool3!);

      await _groupBook.doc().set(groupBookingData.toJson());
      return right(groupBookingData);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      if (e.toString().contains('Null check operator used on a null value')) {
        call('Booking Failed! Fill in all the Data.');
      } else {
        call(e.toString());
      }

      return left(Failure(e.toString()));
    }
  }

  void deleteGroupBooking(String id) {
    _groupBook.doc(id).delete();
  }

  void convertGroupToSingle(
      List<String> list, WidgetRef ref, GroupBookingData data) {
    for (String item in list) {
      try {
        ref.watch(bookingRepositoryProvider).bookRoom(
            BookingData(
                vacantDuration: data.vacantDuration,
                customerName: data.customerName,
                totalPrice: data.totalPrice,
                id: FirebaseFirestore.instance.collection('dog').doc().id,
                personCount: data.personCount,
                phoneNumber: data.phoneNumber,
                byCash: data.byCash,
                districtID: data.districtID,
                roomName: item,
                hasBreakfastService: data.hasBreakfastService,
                unknownBool1: data.unknownBool1,
                unknownBool2: data.unknownBool2,
                unknownBool3: data.unknownBool3),
            (p0) => null,
            ref);
      } catch (e) {
        rethrow;
      }
    }
  }
}

@riverpod
Stream<List<GroupBookingData>> groupBookings(GroupBookingsRef ref) {
  return ref
      .watch(firestoreProvider)
      .collection(FirebaseConstants.groupBookingCollection)
      .snapshots()
      .map(
        (value) => value.docs
            .map(
              (e) => GroupBookingData.fromJson({...e.data(), 'id': e.id}),
            )
            .toList(),
      );

  //List<BookingData> <- List<Map> <- QuerySnapshot <-
}
