// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourlyWeather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HourlyWeather _$HourlyWeatherFromJson(Map<String, dynamic> json) {
  return HourlyWeather(
    json['summary'] as String,
    json['icon'] as String,
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : HourlyWeatherData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HourlyWeatherToJson(HourlyWeather instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'icon': instance.icon,
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };
