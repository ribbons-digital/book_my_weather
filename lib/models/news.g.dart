// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) {
  return News(
    total: json['total'] as int,
    startIndex: json['startIndex'] as int,
    pages: json['pages'] as int,
    pageSize: json['pageSize'] as int,
    currentPage: json['currentPage'] as int,
    results: (json['results'] as List)
        ?.map((e) =>
            e == null ? null : NewsResult.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'total': instance.total,
      'startIndex': instance.startIndex,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
      'pages': instance.pages,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };
