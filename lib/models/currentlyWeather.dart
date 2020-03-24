import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currentlyWeather.g.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class CurrentlyWeather {
  CurrentlyWeather(
    this.time,
    this.summary,
    this.icon,
    this.precipIntensity,
    this.precipProbability,
    this.precipType,
    this.temperature,
    this.apparentTemperature,
    this.dewPoint,
    this.humidity,
    this.pressure,
    this.windSpeed,
    this.windBearing,
    this.windGust,
    this.cloudCover,
    this.uvIndex,
    this.visibility,
    this.ozone,
  );

  @HiveField(0)
  int time;
  @HiveField(1)
  String summary;
  @HiveField(2)
  String icon;
  @HiveField(3)
  double precipIntensity;
  @HiveField(4)
  double precipProbability;
  @HiveField(5)
  String precipType;
  @HiveField(6)
  double temperature;
  @HiveField(7)
  double apparentTemperature;
  @HiveField(8)
  double dewPoint;
  @HiveField(9)
  double humidity;
  @HiveField(10)
  double pressure;
  @HiveField(11)
  double windSpeed;
  @HiveField(12)
  double windGust;
  @HiveField(13)
  int windBearing;
  @HiveField(14)
  double cloudCover;
  @HiveField(15)
  int uvIndex;
  @HiveField(16)
  double visibility;
  @HiveField(17)
  double ozone;

  factory CurrentlyWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentlyWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentlyWeatherToJson(this);
}
