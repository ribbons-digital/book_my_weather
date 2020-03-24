import 'package:book_my_weather/models/hourlyWeatherData.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hourlyWeather.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 3)
class HourlyWeather {
  HourlyWeather(
    this.summary,
    this.icon,
    this.data,
  );

  @HiveField(0)
  String summary;
  @HiveField(1)
  String icon;
  @HiveField(2)
  List<HourlyWeatherData> data;

  factory HourlyWeather.fromJson(Map<String, dynamic> json) =>
      _$HourlyWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyWeatherToJson(this);
}
