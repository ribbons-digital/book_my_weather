import 'package:book_my_weather/models/currentlyWeather.dart';
import 'package:book_my_weather/models/dailyWeather.dart';
import 'package:book_my_weather/models/hourlyWeather.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable(explicitToJson: true)
class Weather {
  Weather({
    this.latitude,
    this.longitude,
    this.timeZone,
    this.hourly,
    this.daily,
    this.currently,
  });

  double latitude;
  double longitude;
  String timeZone;
  @JsonKey(required: false)
  HourlyWeather hourly;
  @JsonKey(required: false)
  DailyWeather daily;
  @JsonKey(required: false)
  CurrentlyWeather currently;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
