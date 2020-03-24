import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dailyWeatherData.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class DailyWeatherData {
  DailyWeatherData(
    this.time,
    this.summary,
    this.icon,
    this.sunriseTime,
    this.sunsetTime,
    this.moonPhase,
    this.precipIntensity,
    this.precipIntensityMax,
    this.precipIntensityMaxTime,
    this.precipProbability,
    this.precipType,
    this.temperatureHigh,
    this.temperatureHighTime,
    this.temperatureLow,
    this.temperatureLowTime,
    this.apparentTemperatureHigh,
    this.apparentTemperatureHighTime,
    this.apparentTemperatureLow,
    this.apparentTemperatureLowTime,
    this.dewPoint,
    this.humidity,
    this.pressure,
    this.windSpeed,
    this.windGust,
    this.windGustTime,
    this.windBearing,
    this.cloudCover,
    this.uvIndex,
    this.uvIndexTime,
    this.visibility,
    this.ozone,
    this.temperatureMin,
    this.temperatureMinTime,
    this.temperatureMax,
    this.temperatureMaxTime,
    this.apparentTemperatureMin,
    this.apparentTemperatureMinTime,
    this.apparentTemperatureMax,
    this.apparentTemperatureMaxTime,
  );

  @HiveField(0)
  int time;
  @HiveField(1)
  String summary;
  @HiveField(2)
  String icon;
  @HiveField(3)
  int sunriseTime;
  @HiveField(4)
  int sunsetTime;
  @HiveField(5)
  double moonPhase;
  @HiveField(6)
  double precipIntensity;
  @HiveField(7)
  double precipIntensityMax;
  @HiveField(8)
  int precipIntensityMaxTime;
  @HiveField(9)
  double precipProbability;
  @HiveField(10)
  String precipType;
  @HiveField(11)
  double temperatureHigh;
  @HiveField(12)
  int temperatureHighTime;
  @HiveField(13)
  double temperatureLow;
  @HiveField(14)
  int temperatureLowTime;
  @HiveField(15)
  double apparentTemperatureHigh;
  @HiveField(16)
  int apparentTemperatureHighTime;
  @HiveField(17)
  double apparentTemperatureLow;
  @HiveField(18)
  int apparentTemperatureLowTime;
  @HiveField(19)
  double dewPoint;
  @HiveField(20)
  double humidity;
  @HiveField(21)
  double pressure;
  @HiveField(22)
  double windSpeed;
  @HiveField(23)
  double windGust;
  @HiveField(24)
  int windGustTime;
  @HiveField(25)
  int windBearing;
  @HiveField(26)
  double cloudCover;
  @HiveField(27)
  int uvIndex;
  @HiveField(28)
  int uvIndexTime;
  @HiveField(29)
  double visibility;
  @HiveField(30)
  double ozone;
  @HiveField(31)
  double temperatureMin;
  @HiveField(32)
  int temperatureMinTime;
  @HiveField(33)
  double temperatureMax;
  @HiveField(34)
  int temperatureMaxTime;
  @HiveField(35)
  double apparentTemperatureMin;
  @HiveField(36)
  int apparentTemperatureMinTime;
  @HiveField(37)
  double apparentTemperatureMax;
  @HiveField(38)
  int apparentTemperatureMaxTime;

  factory DailyWeatherData.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$DailyWeatherDataToJson(this);
}
