import 'package:book_my_weather/models/news.dart';
import 'package:book_my_weather/services/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsList extends StatefulWidget {
  final String newsTags;
  NewsList({@required this.newsTags});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  Future<News> getLatestNews;

  Future<News> _getNews() async {
    NewsModal newsModal = NewsModal();

    return await newsModal.getNews(tagsString: widget.newsTags);
  }

  @override
  void initState() {
    super.initState();
    getLatestNews = _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLatestNews,
      builder: (BuildContext context, AsyncSnapshot<News> snapshot) {
        if (snapshot.hasError) {
          return Text(
            '${snapshot.error}',
            style: TextStyle(color: Colors.white),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitWave(
            color: Colors.white,
            size: 50.0,
          );
        }

        if ((snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.none) &&
            snapshot.hasData &&
            snapshot.data.results.length > 0) {
          final results = snapshot.data.results;

          return RefreshIndicator(
            onRefresh: () {
              return _getNews();
            },
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.results.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0X42FFFFFF),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          results[index].webTitle,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat('MMM dd yyyy hh:mm aaa').format(
                            DateTime.parse(results[index].webPublicationDate),
                          ),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      trailing: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            results[index].sectionName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                      ),
                      onTap: () async {
                        final url = results[index].webUrl;
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                    ),
                  );
                }),
          );
        }

        return Container();
      },
    );
  }
}
