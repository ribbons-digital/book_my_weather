// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourlyWeatherData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HourlyWeatherDataAdapter extends TypeAdapter<HourlyWeatherData> {
  @override
  final typeId = 6;

  @override
  HourlyWeatherData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HourlyWeatherData(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as double,
      fields[4] as double,
      fields[5] as String,
      fields[6] as double,
      fields[7] as double,
      fields[8] as double,
      fields[9] as double,
      fields[10] as double,
      fields[11] as double,
      fields[13] as int,
      fields[12] as double,
      fields[14] as double,
      fields[15] as int,
      fields[16] as double,
      fields[17] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HourlyWeatherData obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.summary)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.precipIntensity)
      ..writeByte(4)
      ..write(obj.precipProbability)
      ..writeByte(5)
      ..write(obj.precipType)
      ..writeByte(6)
      ..write(obj.temperature)
      ..writeByte(7)
      ..write(obj.apparentTemperature)
      ..writeByte(8)
      ..write(obj.dewPoint)
      ..writeByte(9)
      ..write(obj.humidity)
      ..writeByte(10)
      ..write(obj.pressure)
      ..writeByte(11)
      ..write(obj.windSpeed)
      ..writeByte(12)
      ..write(obj.windGust)
      ..writeByte(13)
      ..write(obj.windBearing)
      ..writeByte(14)
      ..write(obj.cloudCover)
      ..writeByte(15)
      ..write(obj.uvIndex)
      ..writeByte(16)
      ..write(obj.visibility)
      ..writeByte(17)
      ..write(obj.ozone);
  }
}

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
