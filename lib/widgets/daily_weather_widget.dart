import 'package:book_my_weather/models/place_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyWeather extends StatelessWidget {
  final String date;
  final String weatherConditionImgPath;
  final String tempRange;
  final int dayIndex;
  final TextStyle dateTextStyle;
  final TextStyle tempRangeTextStyle;
  final Color weatherBoxBackgroundColor;

  DailyWeather({
    this.date,
    @required this.weatherConditionImgPath,
    this.tempRange,
    @required this.dayIndex,
    this.dateTextStyle = const TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 20,
      color: Colors.white,
    ),
    this.tempRangeTextStyle = const TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 20,
      color: Colors.white,
    ),
    this.weatherBoxBackgroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final placeData = Provider.of<PlaceData>(context);
    final place = placeData.places[placeData.currentPlaceIndex];
    final dailyWeatherData = place.weather.daily.data;
    String currentDate = DateFormat('EEE, MMM d')
        .format(DateTime.fromMillisecondsSinceEpoch(
            place.weather.daily.data[dayIndex].time * 1000))
        .toString();
    return Container(
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        color: weatherBoxBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Text(
                currentDate,
                style: dateTextStyle,
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    weatherConditionImgPath,
                    scale: 3.5,
                  ),
                  Text(
                    '${dailyWeatherData[dayIndex].temperatureHigh.toStringAsFixed(0)}º / ${dailyWeatherData[dayIndex].temperatureLow.toStringAsFixed(0)}º',
                    style: tempRangeTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
