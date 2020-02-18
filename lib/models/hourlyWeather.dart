import 'package:book_my_weather/models/hourlyWeatherData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hourlyWeather.g.dart';

@JsonSerializable(explicitToJson: true)
class HourlyWeather {
  HourlyWeather(
    this.summary,
    this.icon,
    this.data,
  );

  String summary;
  String icon;
  List<HourlyWeatherData> data;

  factory HourlyWeather.fromJson(Map<String, dynamic> json) =>
      _$HourlyWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyWeatherToJson(this);
}
