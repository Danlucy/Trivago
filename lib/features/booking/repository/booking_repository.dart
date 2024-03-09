import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trivago/constants/firebase_constants.dart';
import 'package:trivago/core/failure.dart';
import 'package:trivago/core/firebase_provider.dart';
import 'package:trivago/core/type_defs.dart';
import 'package:trivago/models/booked_models/booked_models.dart';

part 'booking_repository.g.dart';

final bookingRepositoryProvider = Provider((ref) {
  return BookingRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _book =>
      _firestore.collection(FirebaseConstants.bookingCollection);

  FutureEither<BookingData> bookRoom(
      BookingData data, Function(String) call, WidgetRef ref) async {
    try {
      await _book.doc(data.id).set(data.toJson());

      return right(data);
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
    _book.doc(id).delete();
  }
}

@riverpod
Stream<List<BookingData>> bookings(BookingsRef ref) {
  return ref
      .watch(firestoreProvider)
      .collection(FirebaseConstants.bookingCollection)
      .snapshots()
      .map(
        (value) => value.docs
            .map(
              (e) => BookingData.fromJson({...e.data(), 'id': e.id}),
            )
            .toList(),
      );
  //List<BookingData> <- List<Map> <- QuerySnapshot <-
}

@riverpod
Stream<List<BookingData>> relevantBookings(BookingsRef ref) {
  return ref
      .watch(firestoreProvider)
      .collection(FirebaseConstants.bookingCollection)
      .orderBy(
        'vacantDuration.start',
      )
      .orderBy('customerName')
      .snapshots()
      .map(
        (value) => value.docs
            .map(
          (e) => BookingData.fromJson({...e.data(), 'id': e.id}),
        )
            .where(
          (element) {
            return element.vacantDuration.end
                .isAfter(DateTime.now().subtract(const Duration(days: 30)));
          },
        ).toList(),
      );

  //List<BookingData> <- List<Map> <- QuerySnapshot <-
}

// Future<List<BookingData>> bookings(BookingsRef ref) async {
//   return ref
//       .watch(firestoreProvider)
//       .collection(FirebaseConstants.bookingCollection)
//       .get()
//       .then(
//         (value) => value.docs
//         .map(
//           (e) => BookingData.fromJson(
//         e.data(),
//       ),
//     )
//         .toList(),
//   );
// }

// final bookingsProvider = FutureProvider(
//   (ref) => ref
//       .watch(firestoreProvider)
//       .collection(FirebaseConstants.bookingCollection)
//       .get()
//       .then(
//         (value) => value.docs
//             .map(
//               (e) => BookingData.fromJson(
//                 e.data(),
//               ),
//             )
//             .toList(),
//       ),
// );
