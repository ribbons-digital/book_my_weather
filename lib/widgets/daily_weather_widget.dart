import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/dailyWeatherData.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyWeather extends StatelessWidget {
  final String date;
  final String tempRange;
  final int dayIndex;
  final TextStyle dateTextStyle;
  final TextStyle tempRangeTextStyle;
  final Color weatherBoxBackgroundColor;
  final List<DailyWeatherData> dailyWeatherData;

  DailyWeather({
    this.date,
    this.tempRange,
    @required this.dayIndex,
    this.dateTextStyle = kDateTextStyle,
    this.tempRangeTextStyle = kTempRangeTextStyle,
    this.weatherBoxBackgroundColor = Colors.black,
    @required this.dailyWeatherData,
  });

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEE, MMM d')
        .format(DateTime.fromMillisecondsSinceEpoch(
            dailyWeatherData[dayIndex].time * 1000))
        .toString();
    WeatherModel weatherModel = WeatherModel();

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
                  weatherModel.getWeatherIcon(
                    condition: dailyWeatherData[dayIndex].icon,
                    iconColor: Color(0xFFFFA500),
                    width: 40.0,
                    height: 40.0,
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
