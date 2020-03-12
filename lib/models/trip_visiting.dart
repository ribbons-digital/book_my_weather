import 'package:cloud_firestore/cloud_firestore.dart';

class TripVisiting {
  final String id;
  final String photo;
  final String placeId;
  final String placeName;
  final String placeType;
  final Timestamp visitingDate;

  TripVisiting({
    this.id,
    this.photo,
    this.placeId,
    this.placeName,
    this.placeType,
    this.visitingDate,
  });

  factory TripVisiting.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return TripVisiting(
      id: doc.documentID,
      photo: data['photo'],
      placeId: data['placeId'],
      placeName: data['placeName'],
      placeType: data['placeType'],
      visitingDate: data['visitingDate'],
    );
  }
}
