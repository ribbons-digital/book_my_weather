import 'package:despicables_me_app/widgets/weather_condition_widget.dart';
import 'package:flutter/material.dart';

class DailyWeatherDetail extends StatelessWidget {
  const DailyWeatherDetail({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.chevron_left,
                size: 50,
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/sunny.png',
                    scale: 1.5,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        '28 º',
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        '9AM',
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 22,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right,
                size: 50,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Intermittent Cloud',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Rain',
                    condition: '0mm',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Winds from',
                    condition: 'ESE',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Dew Point',
                    condition: '23 º',
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Snow',
                    condition: '0cm',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Wind Speed',
                    condition: '17 KPH',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Humidity',
                    condition: '68%',
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'UV Index',
                    condition: '7',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Visibility',
                    condition: '16 KM',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'AQI',
                    condition: '52',
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
