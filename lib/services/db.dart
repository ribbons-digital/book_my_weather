import 'dart:async';
import 'dart:io';

import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_place.dart';
import 'package:book_my_weather/models/trip_todo.dart';
import 'package:book_my_weather/models/trip_visiting.dart';
import 'package:book_my_weather/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

//  Stream<Setting> streamSetting(String id) {
//    return _db.collection('settings').document(id).snapshots().map((snapshot) {
//      if (snapshot.exists) {
//        return Setting.fromFirestore(snapshot);
//      } else {
//        return Setting(
//          id: '',
//          useCelsius: true,
//          places: [],
//        );
//      }
//    });
//  }

  Stream<List<Trip>> streamUpcomingTrips({String uid, String filterString}) {
    final today = DateTime.now().millisecondsSinceEpoch;
    if (filterString == null || filterString.trim() == '') {
      return _db
          .collection('trips')
          .where('createdByUid', isEqualTo: uid)
          .where('endDateInMs', isGreaterThanOrEqualTo: today)
          .snapshots()
          .map((snapshot) {
        return snapshot.documents.map((document) {
          return Trip.fromFirestore(document);
        }).toList();
      });
//      if (isPast) {
//        return _db
//            .collection('trips')
//            .where('createdByUid', isEqualTo: uid)
//            .where('endDateInMs', isLessThan: today)
//            .snapshots()
//            .map((snapshot) {
//          return snapshot.documents.map((document) {
//            return Trip.fromFirestore(document);
//          }).toList();
//        });
//      } else {
//        return _db
//            .collection('trips')
//            .where('createdByUid', isEqualTo: uid)
//            .where('endDateInMs', isGreaterThanOrEqualTo: today)
//            .snapshots()
//            .map((snapshot) {
//          return snapshot.documents.map((document) {
//            return Trip.fromFirestore(document);
//          }).toList();
//        });
//      }
    } else {
      return _db
          .collection('trips')
          .where('createdByUid', isEqualTo: uid)
          .where('searchIndex', arrayContains: filterString)
          .where('endDateInMs', isGreaterThanOrEqualTo: today)
          .snapshots()
          .map((snapshot) {
        return snapshot.documents.map((document) {
          return Trip.fromFirestore(document);
        }).toList();
      });
//      if (isPast) {
//        return _db
//            .collection('trips')
//            .where('createdByUid', isEqualTo: uid)
//            .where('searchIndex', arrayContains: filterString)
//            .where('endDateInMs', isLessThan: today)
//            .snapshots()
//            .map((snapshot) {
//          return snapshot.documents.map((document) {
//            return Trip.fromFirestore(document);
//          }).toList();
//        });
//      } else {
//        return _db
//            .collection('trips')
//            .where('createdByUid', isEqualTo: uid)
//            .where('searchIndex', arrayContains: filterString)
//            .where('endDateInMs', isGreaterThanOrEqualTo: today)
//            .snapshots()
//            .map((snapshot) {
//          return snapshot.documents.map((document) {
//            return Trip.fromFirestore(document);
//          }).toList();
//        });
//      }
    }
  }

  Stream<List<Trip>> streamPastTrips(String uid) {
    final today = DateTime.now().millisecondsSinceEpoch;
    return _db
        .collection('trips')
        .where('createdByUid', isEqualTo: uid)
        .where('endDateInMs', isLessThan: today)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((document) {
        return Trip.fromFirestore(document);
      }).toList();
    });
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
      'searchIndex': newTrip.searchIndex,
      'endDateInMs': newTrip.endDateInMs,
      'currencyRate': newTrip.currencyRate,
      'currencyCode': newTrip.currencyCode,
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
      'searchIndex': updatedTrip.searchIndex,
      'endDateInMs': updatedTrip.endDateInMs,
      'currencyRate': updatedTrip.currencyRate,
      'currencyCode': updatedTrip.currencyCode,
    });
  }

  Future<void> updateTripCurrentWeather(
      {String docId, String newTemp, String newIcon}) {
    return _db.collection('trips').document(docId).updateData({
      'temperature': newTemp,
      'weatherIcon': newIcon,
    });
  }

  Future<void> updateTripCurrency(
      {String docId, double currencyRate, String currencyCode}) {
    return _db.collection('trips').document(docId).updateData({
      'currencyRate': currencyRate,
      'currencyCode': currencyCode,
    });
  }

  Future<void> deleteTrip({String docId}) {
    return _db.collection('trips').document(docId).delete();
  }

  Stream<List<TripTodo>> streamTripTodos(String tripId) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('todos')
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((document) {
        return TripTodo.fromFirestore(document);
      }).toList();
    });
  }

  Future<void> addTodoToTrip(String tripId, TripTodo tripTodo) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('todos')
        .document()
        .setData({
      'content': tripTodo.content,
      'isFinished': false,
    });
  }

  Future<void> toggleTripTodoStatus(
      String tripId, String toDoId, bool currentStatus) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('todos')
        .document(toDoId)
        .updateData({
      'isFinished': !currentStatus,
    });
  }

  Future<void> updateTripTodoContent(
      String tripId, String toDoId, String newContent) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('todos')
        .document(toDoId)
        .updateData({
      'content': newContent,
    });
  }

  Future<void> deleteTripTodo(String tripId, String toDoId) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('todos')
        .document(toDoId)
        .delete();
  }

  Stream<List<TripVisiting>> streamTripVisitings(String tripId) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('visitings')
        .orderBy('visitingDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((document) {
        return TripVisiting.fromFirestore(document);
      }).toList();
    });
  }

  Future<void> addTripVisiting(String tripId, TripVisiting tripVisiting) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('visitings')
        .document()
        .setData({
      'photo': tripVisiting.photo,
      'placeId': tripVisiting.placeId,
      'placeName': tripVisiting.placeName,
      'placeType': tripVisiting.placeType,
      'visitingDate': tripVisiting.visitingDate,
    });
  }

  Future<void> updateTripVisiting(String tripId, TripVisiting tripVisiting) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('visitings')
        .document(tripVisiting.id)
        .updateData({
      'visitingDate': tripVisiting.visitingDate,
    });
  }

  Future<void> deleteTripVisiting(String tripId, String tripVisitingId) {
    return _db
        .collection('trips')
        .document(tripId)
        .collection('visitings')
        .document(tripVisitingId)
        .delete();
  }

  Future<bool> checkExistingDeviceToken({String token, String uid}) async {
    DocumentSnapshot tokens = await _db
        .collection('users')
        .document(uid)
        .collection('tokens')
        .document(token)
        .get();
    return tokens.exists;
  }

  Future<void> setUserDeviceToken({String token, String uid}) async {
    return _db
        .collection('users')
        .document(uid)
        .collection('tokens')
        .document(token)
        .setData({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(), // optional
      'platform': Platform.operatingSystem // optional
    });
  }

  Future<void> updateUserDeviceToken({String token, String uid}) async {
    return _db
        .collection('users')
        .document(uid)
        .collection('tokens')
        .document(token)
        .updateData({
      'token': token,
      'platform': Platform.operatingSystem // optional
    });
  }

  Future<void> addNewUser(User newUser) {
    return _db.collection('users').document().setData({
      'displayName': newUser.displayName,
      'email': newUser.email,
      'uid': newUser.uid,
    });
  }
}
