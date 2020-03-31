import 'package:book_my_weather/models/dailyWeatherData.dart';
import 'package:book_my_weather/models/hourlyWeatherData.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/widgets/weather_condition_widget.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherDetail extends StatelessWidget {
  final int rowIndex;
  final HourlyWeatherData hourlyWeather;
  final DailyWeatherData dailyWeather;

  const WeatherDetail({
    Key key,
    this.rowIndex,
    this.hourlyWeather,
    this.dailyWeather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeatherModel weatherModel = WeatherModel();
    final isHourly = hourlyWeather != null || false;

    final date = dailyWeather != null
        ? DateFormat('EEE, MMM d')
            .format(
                DateTime.fromMillisecondsSinceEpoch(dailyWeather.time * 1000))
            .toString()
        : null;

    final TxtStyle widgetTextStyle = TxtStyle()
      ..fontSize(28.0)
      ..fontWeight(FontWeight.w100);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  if (isHourly)
                    weatherModel.getWeatherIcon(
                      condition: hourlyWeather.icon,
                      iconColor: Color(0xFFFFA500),
                      width: 80.0,
                      height: 80.0,
                    ),
                  if (!isHourly)
                    weatherModel.getWeatherIcon(
                      condition: dailyWeather.icon,
                      iconColor: Color(0xFFFFA500),
                      width: 80.0,
                      height: 80.0,
                    ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Column(
                    children: <Widget>[
                      Txt(
                        isHourly
                            ? '${hourlyWeather.temperature.toStringAsFixed(0)} º'
                            : '${dailyWeather.temperatureHigh.toStringAsFixed(0)}º / ${dailyWeather.temperatureLow.toStringAsFixed(0)}º',
                        style: widgetTextStyle,
                      ),
                      Txt(
                        isHourly
                            ? '${DateFormat('ha').format(DateTime.fromMillisecondsSinceEpoch(hourlyWeather.time * 1000)).toString()}'
                            : date,
                        style: widgetTextStyle,
                      )
                    ],
                  ),
                ],
              ),
              // Icon(
              //   Icons.chevron_right,
              //   size: 50,
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Txt(
            isHourly ? '${hourlyWeather.summary}' : '${dailyWeather.summary}',
            style: TxtStyle()
              ..alignment.center()
              ..fontSize(16.0),
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
                    condition: isHourly
                        ? '${(hourlyWeather.precipProbability * 100).toStringAsFixed(0)}%'
                        : '${(dailyWeather.precipProbability * 100).toStringAsFixed(0)}%',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Wind Speed',
                    condition: isHourly
                        ? '${hourlyWeather.windSpeed} KPH'
                        : '${dailyWeather.windSpeed} KPH',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Dew Point',
                    condition: isHourly
                        ? '${hourlyWeather.dewPoint.toStringAsFixed(0)} º'
                        : '${dailyWeather.dewPoint.toStringAsFixed(0)} ',
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
                    condition: isHourly
                        ? '${hourlyWeather.uvIndex}'
                        : '${dailyWeather.uvIndex}',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Visibility',
                    condition: isHourly
                        ? '${hourlyWeather.visibility.toStringAsFixed(2)} KM'
                        : '${dailyWeather.visibility.toStringAsFixed(2)} KM',
                  ),
                  WeatherCondition(
                    icon: Icons.wb_cloudy,
                    conditionName: 'Humidity',
                    condition: isHourly
                        ? '${(hourlyWeather.humidity * 100).toStringAsFixed(0)}%'
                        : '${(dailyWeather.humidity * 100).toStringAsFixed(0)}%',
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
