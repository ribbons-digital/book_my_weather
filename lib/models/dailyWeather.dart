import 'package:book_my_weather/models/dailyWeatherData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dailyWeather.g.dart';

@JsonSerializable(explicitToJson: true)
class DailyWeather {
  DailyWeather(
    this.summary,
    this.icon,
    this.data,
  );

  String summary;
  String icon;
  List<DailyWeatherData> data;

  factory DailyWeather.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$DailyWeatherToJson(this);
}
