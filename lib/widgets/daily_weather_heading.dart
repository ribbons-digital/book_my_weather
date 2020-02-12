import 'package:despicables_me_app/styleguide.dart';
import 'package:flutter/material.dart';

class DailyWeatherHeading extends StatelessWidget {
  const DailyWeatherHeading({
    Key key,
    @required this.screenHeight,
  }) : super(key: key);

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
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
              '26 º',
              style: AppTheme.display1,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                '35º / 26º',
                style: AppTheme.display2,
              ),
              Text("Fri. 24th Jan.", style: AppTheme.display2),
            ],
          ),
        ],
      ),
    );
  }
}
