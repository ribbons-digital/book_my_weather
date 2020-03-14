import 'package:json_annotation/json_annotation.dart';

part 'news_result.g.dart';

@JsonSerializable(explicitToJson: true)
class NewsResult {
  NewsResult({
    this.id,
    this.type,
    this.sectionId,
    this.sectionName,
    this.webPublicationDate,
    this.webTitle,
    this.webUrl,
  });

  String id;
  String type;
  String sectionId;
  String sectionName;
  String webPublicationDate;
  String webTitle;
  String webUrl;

  factory NewsResult.fromJson(Map<String, dynamic> json) =>
      _$NewsResultFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResultToJson(this);
}
