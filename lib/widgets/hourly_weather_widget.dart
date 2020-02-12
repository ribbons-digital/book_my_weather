import 'package:despicables_me_app/styleguide.dart';
import 'package:flutter/material.dart';

class HourlyWeatherWidget extends StatelessWidget {
  final String hour;
  final String temperature;
  final String weatherIconPath;

  HourlyWeatherWidget(
      {@required this.hour,
      @required this.temperature,
      @required this.weatherIconPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          hour,
          style: AppTheme.display2,
        ),
        SizedBox(
          width: 40.0,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
//                                      top: 18.0,
//                                      bottom: 18.0,
                right: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    temperature,
                    style: AppTheme.display1,
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
