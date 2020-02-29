import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HourlyWeatherWidget extends StatelessWidget {
  final String weatherIconPath;
  final String hour;
  final String temperature;
  final int hourIndex;
  final TextStyle hourTextStyle;
  final TextStyle tempTextStyle;
  final Color weatherBoxBackgroundColor;

  HourlyWeatherWidget({
    @required this.weatherIconPath,
    @required this.hourIndex,
    this.hour,
    this.temperature,
    this.hourTextStyle = AppTheme.display2,
    this.weatherBoxBackgroundColor = Colors.black,
    this.tempTextStyle = AppTheme.display1,
  });

  @override
  Widget build(BuildContext context) {
    final placeData = Provider.of<PlaceData>(context);
    final place = placeData.places[placeData.currentPlaceIndex];
    final hourlyWeatherData = place.weather.hourly.data;

    return Row(
      children: <Widget>[
        Container(
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
                    '${hourlyWeatherData[hourIndex].temperature.toStringAsFixed(0)}',
                    style: tempTextStyle,
                  ),
                  Image.asset(
                    weatherIconPath,
                    scale: 2.5,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
