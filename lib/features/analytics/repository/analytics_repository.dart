import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivago/constants/firebase_constants.dart';

class AnalyticsRepository {
  final FirebaseFirestore _firestore;

  AnalyticsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _booking =>
      _firestore.collection(FirebaseConstants.bookingCollection);
  CollectionReference get _groupBooking =>
      _firestore.collection(FirebaseConstants.bookingCollection);
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
