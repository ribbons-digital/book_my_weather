// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailyWeatherData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyWeatherDataAdapter extends TypeAdapter<DailyWeatherData> {
  @override
  final typeId = 7;

  @override
  DailyWeatherData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyWeatherData(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
      fields[4] as int,
      fields[5] as double,
      fields[6] as double,
      fields[7] as double,
      fields[8] as int,
      fields[9] as double,
      fields[10] as String,
      fields[11] as double,
      fields[12] as int,
      fields[13] as double,
      fields[14] as int,
      fields[15] as double,
      fields[16] as int,
      fields[17] as double,
      fields[18] as int,
      fields[19] as double,
      fields[20] as double,
      fields[21] as double,
      fields[22] as double,
      fields[23] as double,
      fields[24] as int,
      fields[25] as int,
      fields[26] as double,
      fields[27] as int,
      fields[28] as int,
      fields[29] as double,
      fields[30] as double,
      fields[31] as double,
      fields[32] as int,
      fields[33] as double,
      fields[34] as int,
      fields[35] as double,
      fields[36] as int,
      fields[37] as double,
      fields[38] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyWeatherData obj) {
    writer
      ..writeByte(39)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.summary)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.sunriseTime)
      ..writeByte(4)
      ..write(obj.sunsetTime)
      ..writeByte(5)
      ..write(obj.moonPhase)
      ..writeByte(6)
      ..write(obj.precipIntensity)
      ..writeByte(7)
      ..write(obj.precipIntensityMax)
      ..writeByte(8)
      ..write(obj.precipIntensityMaxTime)
      ..writeByte(9)
      ..write(obj.precipProbability)
      ..writeByte(10)
      ..write(obj.precipType)
      ..writeByte(11)
      ..write(obj.temperatureHigh)
      ..writeByte(12)
      ..write(obj.temperatureHighTime)
      ..writeByte(13)
      ..write(obj.temperatureLow)
      ..writeByte(14)
      ..write(obj.temperatureLowTime)
      ..writeByte(15)
      ..write(obj.apparentTemperatureHigh)
      ..writeByte(16)
      ..write(obj.apparentTemperatureHighTime)
      ..writeByte(17)
      ..write(obj.apparentTemperatureLow)
      ..writeByte(18)
      ..write(obj.apparentTemperatureLowTime)
      ..writeByte(19)
      ..write(obj.dewPoint)
      ..writeByte(20)
      ..write(obj.humidity)
      ..writeByte(21)
      ..write(obj.pressure)
      ..writeByte(22)
      ..write(obj.windSpeed)
      ..writeByte(23)
      ..write(obj.windGust)
      ..writeByte(24)
      ..write(obj.windGustTime)
      ..writeByte(25)
      ..write(obj.windBearing)
      ..writeByte(26)
      ..write(obj.cloudCover)
      ..writeByte(27)
      ..write(obj.uvIndex)
      ..writeByte(28)
      ..write(obj.uvIndexTime)
      ..writeByte(29)
      ..write(obj.visibility)
      ..writeByte(30)
      ..write(obj.ozone)
      ..writeByte(31)
      ..write(obj.temperatureMin)
      ..writeByte(32)
      ..write(obj.temperatureMinTime)
      ..writeByte(33)
      ..write(obj.temperatureMax)
      ..writeByte(34)
      ..write(obj.temperatureMaxTime)
      ..writeByte(35)
      ..write(obj.apparentTemperatureMin)
      ..writeByte(36)
      ..write(obj.apparentTemperatureMinTime)
      ..writeByte(37)
      ..write(obj.apparentTemperatureMax)
      ..writeByte(38)
      ..write(obj.apparentTemperatureMaxTime);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyWeatherData _$DailyWeatherDataFromJson(Map<String, dynamic> json) {
  return DailyWeatherData(
    json['time'] as int,
    json['summary'] as String,
    json['icon'] as String,
    json['sunriseTime'] as int,
    json['sunsetTime'] as int,
    (json['moonPhase'] as num)?.toDouble(),
    (json['precipIntensity'] as num)?.toDouble(),
    (json['precipIntensityMax'] as num)?.toDouble(),
    json['precipIntensityMaxTime'] as int,
    (json['precipProbability'] as num)?.toDouble(),
    json['precipType'] as String,
    (json['temperatureHigh'] as num)?.toDouble(),
    json['temperatureHighTime'] as int,
    (json['temperatureLow'] as num)?.toDouble(),
    json['temperatureLowTime'] as int,
    (json['apparentTemperatureHigh'] as num)?.toDouble(),
    json['apparentTemperatureHighTime'] as int,
    (json['apparentTemperatureLow'] as num)?.toDouble(),
    json['apparentTemperatureLowTime'] as int,
    (json['dewPoint'] as num)?.toDouble(),
    (json['humidity'] as num)?.toDouble(),
    (json['pressure'] as num)?.toDouble(),
    (json['windSpeed'] as num)?.toDouble(),
    (json['windGust'] as num)?.toDouble(),
    json['windGustTime'] as int,
    json['windBearing'] as int,
    (json['cloudCover'] as num)?.toDouble(),
    json['uvIndex'] as int,
    json['uvIndexTime'] as int,
    (json['visibility'] as num)?.toDouble(),
    (json['ozone'] as num)?.toDouble(),
    (json['temperatureMin'] as num)?.toDouble(),
    json['temperatureMinTime'] as int,
    (json['temperatureMax'] as num)?.toDouble(),
    json['temperatureMaxTime'] as int,
    (json['apparentTemperatureMin'] as num)?.toDouble(),
    json['apparentTemperatureMinTime'] as int,
    (json['apparentTemperatureMax'] as num)?.toDouble(),
    json['apparentTemperatureMaxTime'] as int,
  );
}

Map<String, dynamic> _$DailyWeatherDataToJson(DailyWeatherData instance) =>
    <String, dynamic>{
      'time': instance.time,
      'summary': instance.summary,
      'icon': instance.icon,
      'sunriseTime': instance.sunriseTime,
      'sunsetTime': instance.sunsetTime,
      'moonPhase': instance.moonPhase,
      'precipIntensity': instance.precipIntensity,
      'precipIntensityMax': instance.precipIntensityMax,
      'precipIntensityMaxTime': instance.precipIntensityMaxTime,
      'precipProbability': instance.precipProbability,
      'precipType': instance.precipType,
      'temperatureHigh': instance.temperatureHigh,
      'temperatureHighTime': instance.temperatureHighTime,
      'temperatureLow': instance.temperatureLow,
      'temperatureLowTime': instance.temperatureLowTime,
      'apparentTemperatureHigh': instance.apparentTemperatureHigh,
      'apparentTemperatureHighTime': instance.apparentTemperatureHighTime,
      'apparentTemperatureLow': instance.apparentTemperatureLow,
      'apparentTemperatureLowTime': instance.apparentTemperatureLowTime,
      'dewPoint': instance.dewPoint,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
      'windSpeed': instance.windSpeed,
      'windGust': instance.windGust,
      'windGustTime': instance.windGustTime,
      'windBearing': instance.windBearing,
      'cloudCover': instance.cloudCover,
      'uvIndex': instance.uvIndex,
      'uvIndexTime': instance.uvIndexTime,
      'visibility': instance.visibility,
      'ozone': instance.ozone,
      'temperatureMin': instance.temperatureMin,
      'temperatureMinTime': instance.temperatureMinTime,
      'temperatureMax': instance.temperatureMax,
      'temperatureMaxTime': instance.temperatureMaxTime,
      'apparentTemperatureMin': instance.apparentTemperatureMin,
      'apparentTemperatureMinTime': instance.apparentTemperatureMinTime,
      'apparentTemperatureMax': instance.apparentTemperatureMax,
      'apparentTemperatureMaxTime': instance.apparentTemperatureMaxTime,
    };
