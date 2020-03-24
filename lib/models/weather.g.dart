// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherAdapter extends TypeAdapter<Weather> {
  @override
  final typeId = 2;

  @override
  Weather read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Weather(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      timeZone: fields[2] as String,
      hourly: fields[3] as HourlyWeather,
      daily: fields[4] as DailyWeather,
      currently: fields[5] as CurrentlyWeather,
      aqi: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Weather obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.timeZone)
      ..writeByte(3)
      ..write(obj.hourly)
      ..writeByte(4)
      ..write(obj.daily)
      ..writeByte(5)
      ..write(obj.currently)
      ..writeByte(6)
      ..write(obj.aqi);
  }
}

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
    currently: json['currently'] == null
        ? null
        : CurrentlyWeather.fromJson(json['currently'] as Map<String, dynamic>),
    aqi: (json['aqi'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timeZone': instance.timeZone,
      'hourly': instance.hourly?.toJson(),
      'daily': instance.daily?.toJson(),
      'currently': instance.currently?.toJson(),
      'aqi': instance.aqi,
    };
