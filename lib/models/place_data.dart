import 'dart:collection';

import 'package:book_my_weather/models/place.dart';
import 'package:flutter/foundation.dart';

class PlaceData extends ChangeNotifier {
  List<Place> _places = [];

  UnmodifiableListView<Place> get places => UnmodifiableListView(_places);

  int get placesCount {
    return _places.length;
  }

  void addPlace(Place newPlace) {
    Place place = Place(
      name: newPlace.name,
      address: newPlace.address,
      country: newPlace.country,
      weather: newPlace.weather,
      latitude: newPlace.latitude,
      longitude: newPlace.longitude,
    );

    _places.add(place);
    notifyListeners();
  }

  void updatePlace(int index, Place updatedPlace) {
    places[index] = updatedPlace;
    notifyListeners();
  }

  void removePlace(int index) {
    if (places.length > 0) {
      places.removeAt(index);
      notifyListeners();
    }
  }
}
