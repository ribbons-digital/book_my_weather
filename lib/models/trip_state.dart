import 'package:flutter/material.dart';

class TripState extends ChangeNotifier {
  int _selectedIndex = 0;
  String _tripId = '';

  int get selectedIndex => _selectedIndex;
  String get tripId => _tripId;

  void updateSelectedTrip(int newIndex, String tripId) {
    _selectedIndex = newIndex;
    _tripId = tripId;
    notifyListeners();
  }
}
