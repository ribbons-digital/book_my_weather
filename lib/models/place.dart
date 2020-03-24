import 'package:book_my_weather/models/weather.dart';
import 'package:hive/hive.dart';

part 'place.g.dart';

@HiveType(typeId: 1)
class Place {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String country;
  @HiveField(2)
  final String address;
  @HiveField(3)
  Weather weather;
  @HiveField(4)
  double latitude;
  @HiveField(5)
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

//@JsonSerializable(explicitToJson: true)
//class Place {
//  final String name;
//  @JsonKey(required: false)
//  final String country;
//  final String address;
//  @JsonKey(required: false)
//  Weather weather;
//  double latitude;
//  double longitude;
//
//  Place({
//    this.name,
//    this.country,
//    this.address,
//    this.weather,
//    this.latitude,
//    this.longitude,
//  });
//
//  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
//
//  Map<String, dynamic> toJson() => _$PlaceToJson(this);
//}
