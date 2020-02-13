import 'package:despicables_me_app/styleguide.dart';
import 'package:flutter/material.dart';

class HourlyWeatherWidget extends StatelessWidget {
  final String hour;
  final String temperature;
  final String weatherIconPath;
  final TextStyle hourTextStyle;
  final TextStyle tempTextStyle;
  final Color weatherBoxBackgroundColor;

  HourlyWeatherWidget({
    @required this.hour,
    @required this.temperature,
    @required this.weatherIconPath,
    this.hourTextStyle = AppTheme.display2,
    this.weatherBoxBackgroundColor = Colors.black,
    this.tempTextStyle = AppTheme.display1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 5,
          child: Text(
            hour,
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
                    temperature,
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
