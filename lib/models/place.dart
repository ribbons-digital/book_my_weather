import 'package:book_my_weather/models/weather.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable(explicitToJson: true)
class Place {
  final String name;
  @JsonKey(required: false)
  final String country;
  final String address;
  @JsonKey(required: false)
  Weather weather;
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

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}
