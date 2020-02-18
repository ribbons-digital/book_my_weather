// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) {
  return Weather(
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
    json['timeZone'] as String,
    json['hourly'] == null
        ? null
        : HourlyWeather.fromJson(json['hourly'] as Map<String, dynamic>),
    json['daily'] == null
        ? null
        : DailyWeather.fromJson(json['daily'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timeZone': instance.timeZone,
      'hourly': instance.hourly?.toJson(),
      'daily': instance.daily?.toJson(),
    };
