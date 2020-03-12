import 'package:book_my_weather/models/dailyWeatherData.dart';
import 'package:book_my_weather/models/hourlyWeatherData.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/styleguide.dart';
import 'package:flutter/material.dart';

class DailyWeatherHeading extends StatelessWidget {
  const DailyWeatherHeading({
    Key key,
    @required this.screenHeight,
    this.dailyWeather,
    this.hourlyWeather,
    this.today,
  }) : super(key: key);

  final double screenHeight;
  final DailyWeatherData dailyWeather;
  final HourlyWeatherData hourlyWeather;
  final String today;

  @override
  Widget build(BuildContext context) {
//    final placeData = Provider.of<PlaceData>(context);
//    final place = placeData.places[placeData.currentPlaceIndex];
//    String date = DateFormat('EEE, MMM d')
//        .format(DateTime.fromMillisecondsSinceEpoch(
//            place.weather.daily.data[0].time * 1000))
//        .toString();
//    final hourlyWeather = place.weather.hourly.data;
//    final dailyWeather = place.weather.daily.data;
    WeatherModel weatherModel = WeatherModel();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Hero(
            tag: "weather-icon",
            child: weatherModel.getWeatherIcon(
              condition: hourlyWeather.icon,
              iconColor: Color(0xFFFFA500),
              width: 100.0,
              height: 100.0,
            ),
          ),
          SizedBox(
            width: 6.0,
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${hourlyWeather.temperature.toStringAsFixed(0)} º',
              style: AppTheme.display1,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                '${dailyWeather.temperatureHigh.toStringAsFixed(0)}º / ${dailyWeather.temperatureLow.toStringAsFixed(0)}º',
                style: AppTheme.display2,
              ),
              Text(today, style: AppTheme.display2),
            ],
          ),
        ],
      ),
    );
  }
}
