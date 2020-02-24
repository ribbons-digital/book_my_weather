// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) {
  return Weather(
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    timeZone: json['timeZone'] as String,
    hourly: json['hourly'] == null
        ? null
        : HourlyWeather.fromJson(json['hourly'] as Map<String, dynamic>),
    daily: json['daily'] == null
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
