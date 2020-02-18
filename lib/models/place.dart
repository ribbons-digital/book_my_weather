import 'package:book_my_weather/models/weather.dart';

class Place {
  final String name;
  final String country;
  final String address;
  final Weather weather;
  double latitude;
  double longitude;

  Place({
    this.name,
    this.country,
    this.address,
    this.weather,
    this.latitude,
    this.longitude,
  });
}
