import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyWeatherHeading extends StatelessWidget {
  const DailyWeatherHeading({
    Key key,
    @required this.screenHeight,
  }) : super(key: key);

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    final placeData = Provider.of<PlaceData>(context);
    final place = placeData.places[placeData.currentPlaceIndex];
    String date = DateFormat('EEE, MMM d')
        .format(DateTime.fromMillisecondsSinceEpoch(
            place.weather.daily.data[0].time * 1000))
        .toString();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Hero(
            tag: "weather-icon",
            child: Image.asset(
              'assets/images/sunny.png',
              scale: 1 / (screenHeight / 100) * 10,
            ),
          ),
          SizedBox(
            width: 6.0,
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${place.weather.hourly.data[0].temperature.toStringAsFixed(0)} º',
              style: AppTheme.display1,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                '${place.weather.daily.data[0].temperatureHigh.toStringAsFixed(0)}º / ${place.weather.daily.data[0].temperatureLow.toStringAsFixed(0)}º',
                style: AppTheme.display2,
              ),
              Text(date, style: AppTheme.display2),
            ],
          ),
        ],
      ),
    );
  }
}
