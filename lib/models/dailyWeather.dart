import 'package:book_my_weather/models/dailyWeatherData.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dailyWeather.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 4)
class DailyWeather {
  DailyWeather(
    this.summary,
    this.icon,
    this.data,
  );

  @HiveField(0)
  String summary;
  @HiveField(1)
  String icon;
  @HiveField(2)
  List<DailyWeatherData> data;

  factory DailyWeather.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$DailyWeatherToJson(this);
}
