import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/widgets/weather_condition_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeatherDetail extends StatelessWidget {
  final int rowIndex;
  final bool isHourly;
  const WeatherDetail({
    Key key,
    this.rowIndex,
    this.isHourly = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeData = Provider.of<PlaceData>(context);
    final place = placeData.places[placeData.currentPlaceIndex];
    final hourlyWeather = placeData
        .places[placeData.currentPlaceIndex].weather.hourly.data[rowIndex];
    final dailyWeather = isHourly
        ? null
        : placeData
            .places[placeData.currentPlaceIndex].weather.daily.data[rowIndex];
    final date = isHourly
        ? null
        : DateFormat('EEE, MMM d')
            .format(DateTime.fromMillisecondsSinceEpoch(
                place.weather.daily.data[rowIndex].time * 1000))
            .toString();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Icon(
              //   Icons.chevron_left,
              //   size: 50,
              // ),
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
                        isHourly
                            ? '${hourlyWeather.temperature.toStringAsFixed(0)} º'
                            : '${dailyWeather.temperatureHigh.toStringAsFixed(0)}º / ${dailyWeather.temperatureLow.toStringAsFixed(0)}º',
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        isHourly
                            ? '${DateFormat('ha').format(DateTime.fromMillisecondsSinceEpoch(hourlyWeather.time * 1000)).toString()}'
                            : date,
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 22,
                        ),
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
          child: Text(
            isHourly ? '${hourlyWeather.summary}' : '${dailyWeather.summary}',
            style: TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
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
                        : '${(hourlyWeather.precipProbability * 100).toStringAsFixed(0)}%',
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
