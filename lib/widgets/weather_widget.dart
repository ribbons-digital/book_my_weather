//import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/pages/weather_detail_screen.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/styleguide.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../styleguide.dart';

class WeatherWidget extends StatelessWidget {
  final placeIndex;

  WeatherWidget({@required this.placeIndex});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final settingsBox = Hive.box('settings');

    final places = (settingsBox.get(0) as Setting).places;
    WeatherModel weatherModel = WeatherModel();
    final currentHourlyWeather = places[placeIndex].weather.hourly.data[0];
    final currentDailyWeather = places[placeIndex].weather.daily.data[0];

    return InkWell(
      onTap: () {
//        placeData.updateCurrentPlaceIndex(placeIndex);

        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 350),
                pageBuilder: (context, _, __) =>
                    WeatherDetailScreen(place: places[placeIndex])));
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CharacterCardBackgroundClipper(),
              child: Hero(
                tag: "background-${places[placeIndex].name}",
                child: Container(
                  height: 0.6 * screenHeight,
                  width: 0.9 * screenWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0x42436DA6), Color(0xFF000000)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(
                0, screenHeight / 10000 + screenHeight > 600 ? 0.3 : 0),
            child: Container(
              height: screenHeight / 2,
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: "weather-icon",
                    child: weatherModel.getWeatherIcon(
                      condition: currentHourlyWeather.icon,
                      iconColor: Color(0xFFFFA500),
                      width: screenHeight < 600 ? 75.0 : 100.0,
                      height: screenHeight < 600 ? 75.0 : 100.0,
                    ),
                  ),
                  Text(
                    '${currentHourlyWeather.temperature.toStringAsFixed(0)}º',
                    style: AppTheme.display1,
                  ),
                  Text(
                    '${currentDailyWeather.temperatureHigh.toStringAsFixed(0)}º / ${places[placeIndex].weather.daily.data[0].temperatureLow.toStringAsFixed(0)}º',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (screenHeight > 812)
            Positioned(
                bottom: screenHeight / 5.2,
                left: 40,
                right: 40,
                child: Column(
                  children: <Widget>[
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        places[placeIndex].weather.hourly.summary,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        places[placeIndex].weather.daily.summary,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                )),
          Positioned(
            bottom: screenHeight > 600 && screenHeight < 768
                ? screenHeight / 30
                : screenHeight > 768 ? screenHeight / 30 : screenHeight / 20,
            left: 15,
            right: 15,
            child: Container(
              width: screenWidth * 0.9,
              child: Row(
                children: List.generate(5, (index) {
                  final data = places[placeIndex].weather.hourly.data[index];
                  return Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${DateFormat('ha').format(DateTime.fromMillisecondsSinceEpoch(data.time * 1000)).toString()}',
                          style: AppTheme.small,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
//                          child: _SpinningSun(),
                          child: weatherModel.getWeatherIcon(
                            condition: data.icon,
                            iconColor: Color(0xFFFFA500),
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),
                        Text(
                          '${data.temperature.toStringAsFixed(0)}º',
                          style: AppTheme.small,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CharacterCardBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    double curveDistance = 40;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(
        1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width + 1, size.height - 1, size.width,
        size.height - curveDistance);
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(size.width - 1, 0,
        size.width - curveDistance - 5, 0 + curveDistance / 3);
    clippedPath.lineTo(curveDistance, size.height * 0.29);
    clippedPath.quadraticBezierTo(
        1, (size.height * 0.30) + 10, 0, size.height * 0.4);
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _SpinningSun extends StatefulWidget {
  @override
  __SpinningSunState createState() => __SpinningSunState();
}

class __SpinningSunState extends State<_SpinningSun> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.only(top: 5, bottom: 10),
      child: FlareActor(
        'assets/images/Spinning Sun.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'Spinning',
      ),
    );
  }
}
