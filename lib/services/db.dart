import 'dart:async';

import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<Setting> streamSetting(String id) {
    return _db
        .collection('settings')
        .document(id)
        .snapshots()
        .map((snapshot) => Setting.fromFirestore(snapshot));
  }

  Future<void> updateUnit(String id, bool useCelsius) {
    return _db
        .collection('settings')
        .document(id)
        .setData({'useCelsius': useCelsius});
  }

  Future<void> updatePlaces(String id, Place place) {

    return _db.collection('settings').document(id).updateData({
      'places': FieldValue.arrayUnion([{
        'name': place.name,
        'address': place.address,
        'latitude': place.latitude,
        'longitude': place.longitude,
      }])
    });
  }
}
