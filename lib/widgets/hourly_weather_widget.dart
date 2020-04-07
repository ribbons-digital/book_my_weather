import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/hourlyWeatherData.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyWeatherWidget extends StatelessWidget {
  final String hour;
  final String temperature;
  final int hourIndex;
  final TextStyle hourTextStyle;
  final TextStyle tempTextStyle;
  final Color weatherBoxBackgroundColor;
  final List<HourlyWeatherData> hourlyWeatherData;

  HourlyWeatherWidget({
    @required this.hourIndex,
    this.hour,
    this.temperature,
    this.hourTextStyle = AppTheme.display2,
    this.weatherBoxBackgroundColor = Colors.black,
    this.tempTextStyle = kTempRangeTextStyle,
    @required this.hourlyWeatherData,
  });

  @override
  Widget build(BuildContext context) {
    WeatherModel weatherModel = WeatherModel();

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 5,
            child: Text(
              '${DateFormat('ha').format(DateTime.fromMillisecondsSinceEpoch(hourlyWeatherData[hourIndex].time * 1000)).toString()}',
              style: hourTextStyle,
            ),
          ),
          SizedBox(
            width: 40.0,
          ),
          Expanded(
            child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      '${hourlyWeatherData[hourIndex].temperature.toStringAsFixed(0)}º',
                      style: tempTextStyle,
                    ),
                    weatherModel.getWeatherIcon(
                      condition: hourlyWeatherData[hourIndex].icon,
                      iconColor: Color(0xFFFFA500),
                      width: 40.0,
                      height: 40.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
