import 'dart:async';

import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<Setting> streamSetting(String id) {
    return _db.collection('settings').document(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Setting.fromFirestore(snapshot);
      } else {
        return Setting(
          id: '',
          useCelsius: true,
          places: [],
        );
      }
    });
  }

  Stream<List<Trip>> streamTrips({String uid, String filterString}) {
    if (filterString != null) {
      return _db
          .collection('trips')
          .where('createdByUid', isEqualTo: uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.documents.map((document) {
          return Trip.fromFirestore(document);
        }).toList();
      });
    } else {
      return _db
          .collection('trips')
          .where('createdByUid', isEqualTo: uid)
          .where('destination', isEqualTo: filterString)
          .snapshots()
          .map((snapshot) {
        return snapshot.documents.map((document) {
          return Trip.fromFirestore(document);
        }).toList();
      });
    }
  }

  Stream<List<TripPlace>> streamTripPlaces(String tripId) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('places')
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((document) {
        return TripPlace.fromFirestore(document);
      });
    });
  }

  Future<void> updateUnit(String id, bool useCelsius) {
    return _db
        .collection('settings')
        .document(id)
        .setData({'useCelsius': useCelsius});
  }

  Future<void> updatePlaces(String id, Place place) {
    return _db.collection('settings').document(id).updateData({
      'places': FieldValue.arrayUnion([
        {
          'name': place.name,
          'address': place.address,
          'latitude': place.latitude,
          'longitude': place.longitude,
        }
      ])
    });
  }

  Future<void> addNewSetting(String id, Place place) {
    return _db.collection('settings').document(id).setData({
      'useCelsius': true,
      'places': FieldValue.arrayUnion([
        {
          'name': place.name,
          'address': place.address,
          'latitude': place.latitude,
          'longitude': place.longitude,
        }
      ]),
    });
  }

  Future<void> addTrip(Trip newTrip) {
    return _db.collection('trips').document().setData({
      'createdByUid': newTrip.createdByUid,
      'name': newTrip.name,
      'destination': newTrip.destination,
      'startDate': newTrip.startDate,
      'endDate': newTrip.endDate,
      'description': newTrip.description,
      'location': newTrip.location,
      'heroImages': newTrip.heroImages,
      'temperature': newTrip.temperature,
      'weatherIcon': newTrip.weatherIcon,
    });
  }

  Future<void> updateTrip({String docId, Trip updatedTrip}) {
    return _db.collection('trips').document(docId).updateData({
      'createdByUid': updatedTrip.createdByUid,
      'name': updatedTrip.name,
      'destination': updatedTrip.destination,
      'startDate': updatedTrip.startDate,
      'endDate': updatedTrip.endDate,
      'description': updatedTrip.description,
      'location': updatedTrip.location,
      'temperature': updatedTrip.temperature,
      'weatherIcon': updatedTrip.weatherIcon,
    });
  }

  Future<void> updateTripCurrentWeather(
      {String docId, String newTemp, String newIcon}) {
    return _db.collection('trips').document(docId).updateData({
      'temperature': newTemp,
      'weatherIcon': newIcon,
    });
  }
}
