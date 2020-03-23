import 'package:book_my_weather/models/trip.dart';
import 'package:flutter/material.dart';

class TripState extends ChangeNotifier {
  int _selectedIndex = 0;
  Trip _trip;

  int get selectedIndex => _selectedIndex;
  String get tripId => _trip.id;
  bool get isTripEnded =>
      _trip.endDateInMs < DateTime.now().millisecondsSinceEpoch;

  void updateSelectedTrip(int newIndex, Trip trip) {
    _selectedIndex = newIndex;
    _trip = trip;
    notifyListeners();
  }
}
