import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;
  List<Placemark> placeMark;

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPlaceMarkFromAddress(
      {String address = 'melbourne, VIC'}) async {
    try {
      List<Placemark> places = await Geolocator().placemarkFromAddress(address);

      placeMark = places;
      latitude = places[0].position.latitude;
      longitude = places[0].position.longitude;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPlaceMarkFromCoordinates({double lat, double lng}) async {
    try {
      List<Placemark> places =
          await Geolocator().placemarkFromCoordinates(lat, lng);
      placeMark = places;
      latitude = lat;
      longitude = lng;
    } catch (e) {
      print(e);
    }
  }
}
