import 'package:book_my_weather/models/news_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable(explicitToJson: true)
class News {
  News({
    this.total,
    this.startIndex,
    this.pages,
    this.pageSize,
    this.currentPage,
    this.results,
  });

  int total;
  int startIndex;
  int pageSize;
  int currentPage;
  int pages;
  List<NewsResult> results;

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
