// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailyWeather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyWeather _$DailyWeatherFromJson(Map<String, dynamic> json) {
  return DailyWeather(
    json['summary'] as String,
    json['icon'] as String,
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : DailyWeatherData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DailyWeatherToJson(DailyWeather instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'icon': instance.icon,
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };
