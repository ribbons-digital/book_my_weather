import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String timeStampToDateString(Timestamp timestamp) {
  return DateFormat('yMMMMd').format(timestamp.toDate());
}

String timeStampToISOString(Timestamp timestamp) {
  return timestamp.toDate().toIso8601String();
}
