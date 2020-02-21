import 'package:cloud_firestore/cloud_firestore.dart';

class Setting {
  final String id;
  bool useCelsius;

  Setting({this.id, this.useCelsius});

  factory Setting.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Setting(
      id: doc.documentID,
      useCelsius: data['useCelsius'],
    );
  }
}
