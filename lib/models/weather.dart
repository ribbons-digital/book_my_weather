import 'package:book_my_weather/models/currentlyWeather.dart';
import 'package:book_my_weather/models/dailyWeather.dart';
import 'package:book_my_weather/models/hourlyWeather.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class Weather {
  Weather({
    this.latitude,
    this.longitude,
    this.timeZone,
    this.hourly,
    this.daily,
    this.currently,
    this.aqi,
  });

  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  @HiveField(2)
  String timeZone;

  @HiveField(3)
  @JsonKey(required: false)
  HourlyWeather hourly;

  @HiveField(4)
  @JsonKey(required: false)
  DailyWeather daily;

  @HiveField(5)
  @JsonKey(required: false)
  CurrentlyWeather currently;

  @HiveField(6)
  double aqi;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
