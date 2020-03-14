// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsResult _$NewsResultFromJson(Map<String, dynamic> json) {
  return NewsResult(
    id: json['id'] as String,
    type: json['type'] as String,
    sectionId: json['sectionId'] as String,
    sectionName: json['sectionName'] as String,
    webPublicationDate: json['webPublicationDate'] as String,
    webTitle: json['webTitle'] as String,
    webUrl: json['webUrl'] as String,
  );
}

Map<String, dynamic> _$NewsResultToJson(NewsResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'sectionId': instance.sectionId,
      'sectionName': instance.sectionName,
      'webPublicationDate': instance.webPublicationDate,
      'webTitle': instance.webTitle,
      'webUrl': instance.webUrl,
    };
