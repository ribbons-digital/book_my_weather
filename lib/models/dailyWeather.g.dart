// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailyWeather.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyWeatherAdapter extends TypeAdapter<DailyWeather> {
  @override
  final typeId = 4;

  @override
  DailyWeather read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyWeather(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as List)?.cast<DailyWeatherData>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyWeather obj) {
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
