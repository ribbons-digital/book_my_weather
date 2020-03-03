import 'package:json_annotation/json_annotation.dart';

part 'currentlyWeather.g.dart';

@JsonSerializable()
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

  int time;
  String summary;
  String icon;
  double precipIntensity;
  double precipProbability;
  String precipType;
  double temperature;
  double apparentTemperature;
  double dewPoint;
  double humidity;
  double pressure;
  double windSpeed;
  double windGust;
  int windBearing;
  double cloudCover;
  int uvIndex;
  double visibility;
  double ozone;

  factory CurrentlyWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentlyWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentlyWeatherToJson(this);
}
