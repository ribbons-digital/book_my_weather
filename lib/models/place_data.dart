import 'dart:collection';

import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:flutter/foundation.dart';

class PlaceData extends ChangeNotifier {
  List<Place> _places = [
//    Place(
//      name: 'Taipei',
//      address: 'Taipei city',
//      country: 'Taiwan',
//      latitude: 25.069417,
//      longitude: 121.444572,
//    ),
//    Place(
//      name: 'Waverton',
//      address: 'Waverton, NSW',
//      country: 'Australia',
//      latitude: -33.838030,
//      longitude: 151.199273,
//    )
  ];

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

  void updatePlaceWeather(int index, Weather updatedWeather) {
    places[index].weather = updatedWeather;
    notifyListeners();
  }

  void updatePlaces(List<Place> places) {
    _places = places;
    notifyListeners();
  }

  void removePlace(int index) {
    if (places.length > 0) {
      places.removeAt(index);
      notifyListeners();
    }
  }
}
