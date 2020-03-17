import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/widgets/news_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  final Function selectHomeIndex;

  NewsScreen({this.selectHomeIndex});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with WidgetsBindingObserver {
  String tagsString;
  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      _notification = state;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_notification != null && _notification.index == 0) {
      widget.selectHomeIndex(0);
    }
    final trips = Provider.of<List<Trip>>(context, listen: false);
    if (trips != null && trips.length > 0) {
      final destinations = trips.map((trip) => trip.destination).toList();
      final str = destinations.join(',').replaceAll(' ', '');

      print(str);
      setState(() {
        tagsString = str;
      });
    } else {
      setState(() {
        tagsString = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tagsString == null) {
      return SpinKitWave(
        color: Colors.white,
        size: 50.0,
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Latest News'),
        ),
        body: NewsList(
          newsTags: tagsString,
        ),
      ),
    );
  }
}
