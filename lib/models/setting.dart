import 'package:book_my_weather/models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Setting {
  String id;
  bool useCelsius;
  List<Place> places;

  Setting({this.id, this.useCelsius, this.places});

  factory Setting.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    List<Place> places = [];
    if (data['places'] != null) {
      places = (data['places'] as List)
          .map((place) => Place.fromJson(place))
          .toList();
    }

    return Setting(
      id: doc.documentID,
      useCelsius: data['useCelsius'] ?? true,
      places: places,
    );
  }
}
