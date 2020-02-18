// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourlyWeatherData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HourlyWeatherData _$HourlyWeatherDataFromJson(Map<String, dynamic> json) {
  return HourlyWeatherData(
    json['time'] as int,
    json['summary'] as String,
    json['icon'] as String,
    (json['precipIntensity'] as num)?.toDouble(),
    (json['precipProbability'] as num)?.toDouble(),
    json['precipType'] as String,
    (json['temperature'] as num)?.toDouble(),
    (json['apparentTemperature'] as num)?.toDouble(),
    (json['dewPoint'] as num)?.toDouble(),
    (json['humidity'] as num)?.toDouble(),
    (json['pressure'] as num)?.toDouble(),
    (json['windSpeed'] as num)?.toDouble(),
    json['windBearing'] as int,
    (json['windGust'] as num)?.toDouble(),
    (json['cloudCover'] as num)?.toDouble(),
    json['uvIndex'] as int,
    (json['visibility'] as num)?.toDouble(),
    (json['ozone'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$HourlyWeatherDataToJson(HourlyWeatherData instance) =>
    <String, dynamic>{
      'time': instance.time,
      'summary': instance.summary,
      'icon': instance.icon,
      'precipIntensity': instance.precipIntensity,
      'precipProbability': instance.precipProbability,
      'precipType': instance.precipType,
      'temperature': instance.temperature,
      'apparentTemperature': instance.apparentTemperature,
      'dewPoint': instance.dewPoint,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
      'windSpeed': instance.windSpeed,
      'windGust': instance.windGust,
      'windBearing': instance.windBearing,
      'cloudCover': instance.cloudCover,
      'uvIndex': instance.uvIndex,
      'visibility': instance.visibility,
      'ozone': instance.ozone,
    };
