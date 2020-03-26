import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/news.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class NewsModal {
  Future<News> getNews({@required tagsString}) async {
    final fromDate = DateFormat('yyyy-MM-dd').format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch - (86400000 * 3)));
    final url = '$kGuardianNewsAPIBaseURL$tagsString&from-date=$fromDate';
    NetworkHelper networkHelper = NetworkHelper(url);

    Map<String, dynamic> result = await networkHelper.getData();

    return News.fromJson(result['response']);
  }
}
