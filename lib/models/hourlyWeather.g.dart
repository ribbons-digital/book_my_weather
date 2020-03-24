// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourlyWeather.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HourlyWeatherAdapter extends TypeAdapter<HourlyWeather> {
  @override
  final typeId = 3;

  @override
  HourlyWeather read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HourlyWeather(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as List)?.cast<HourlyWeatherData>(),
    );
  }

  @override
  void write(BinaryWriter writer, HourlyWeather obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.summary)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.data);
  }
}

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
