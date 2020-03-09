import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const darkSkyApiUrl = 'https://api.darksky.net/forecast';

enum RequestedWeatherType { Hourly, Daily, Currently, All }

class WeatherModel {
  Future<Weather> getLocationWeather({
    @required RequestedWeatherType type,
    @required bool useCelsius,
    double latitude,
    double longitude,
  }) async {
    String requestUrl;
    String aqiRequestUrl;

    print('called');
    List<String> excludes = type == RequestedWeatherType.Hourly
        ? ["currently", "minutely", "daily", "alerts", "flags"]
        : type == RequestedWeatherType.Daily
            ? ["currently", "minutely", "hourly", "alerts", "flags"]
            : type == RequestedWeatherType.Currently
                ? ["daily", "minutely", "hourly", "alerts", "flags"]
                : ["currently", "minutely", "alerts", "flags"];
    if (latitude != null && longitude != null) {
      requestUrl = useCelsius
          ? '$darkSkyApiUrl/$kDarkSkyAPIKey/$latitude,$longitude?units=si&?exclude=$excludes'
          : '$darkSkyApiUrl/$kDarkSkyAPIKey/$latitude,$longitude?exclude=$excludes';
      aqiRequestUrl =
          kAqiCNAPIBaseURL + '$latitude;$longitude/?token=$kAqiCNAPIToken';
    } else {
      Location location = Location();
      await location.getLocation();
      final latitude = location.latitude;
      final longitude = location.longitude;

      requestUrl = useCelsius
          ? '$darkSkyApiUrl/$kDarkSkyAPIKey/$latitude,$longitude?units=si&?exclude=$excludes'
          : '$darkSkyApiUrl/$kDarkSkyAPIKey/$latitude,$longitude?exclude=$excludes';
      aqiRequestUrl =
          kAqiCNAPIBaseURL + '$latitude;$longitude/?token=$kAqiCNAPIToken';
    }

    NetworkHelper networkHelper = NetworkHelper(requestUrl);

    NetworkHelper aqiNetworkHelper = NetworkHelper(aqiRequestUrl);

    Map<String, dynamic> hourlyWeatherMap = await networkHelper.getData();

    Map<String, dynamic> aqi = await aqiNetworkHelper.getData();

    hourlyWeatherMap['aqi'] = aqi['data']['aqi'];

    return Weather.fromJson(hourlyWeatherMap);
  }

  Widget getWeatherIcon(
      {String condition, Color iconColor, double width, double height}) {
    if (condition == kClearDay) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-day-sunny-overcast.svg',
        color: iconColor,
        semanticsLabel: kClearDay,
        width: width,
        height: height,
      );
    } else if (condition == kClearNight) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-night-clear.svg',
        color: iconColor,
        semanticsLabel: kClearNight,
        width: width,
        height: height,
      );
    } else if (condition == kRain) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-rain.svg',
        color: iconColor,
        semanticsLabel: kRain,
        width: width,
        height: height,
      );
    } else if (condition == kSnow) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-snow.svg',
        color: iconColor,
        semanticsLabel: kSnow,
        width: width,
        height: height,
      );
    } else if (condition == kSleet) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-sleet.svg',
        color: iconColor,
        semanticsLabel: kSleet,
        width: width,
        height: height,
      );
    } else if (condition == kWind) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-windy.svg',
        color: iconColor,
        semanticsLabel: kWind,
        width: width,
        height: height,
      );
    } else if (condition == kFog) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-fog.svg',
        color: iconColor,
        semanticsLabel: kFog,
        width: width,
        height: height,
      );
    } else if (condition == kCloudy) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-cloudy.svg',
        color: iconColor,
        semanticsLabel: kCloudy,
        width: width,
        height: height,
      );
    } else if (condition == kPartlyCloudyDay) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-day-cloudy.svg',
        color: iconColor,
        semanticsLabel: kPartlyCloudyDay,
        width: width,
        height: height,
      );
    } else if (condition == kPartlyCloudyNight) {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-night-cloudy.svg',
        color: iconColor,
        semanticsLabel: kPartlyCloudyNight,
        width: width,
        height: height,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/weather_icons/wi-day-sunny-overcast.svg',
        color: iconColor,
        semanticsLabel: kClearDay,
        width: width,
        height: height,
      );
    }
  }
}
