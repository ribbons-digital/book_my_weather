import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:flutter/cupertino.dart';

const darkSkyApiUrl = 'https://api.darksky.net/forecast';

enum RequestedWeatherType { Hourly, Daily, Both }

class WeatherModel {
//  Future<dynamic> getCityWeather(String cityName) async {
//    String url = '$darkSkyApiUrl?q=$cityName&appid=$apiKey&units=metric';
//    NetworkHelper networkHelper = NetworkHelper(url);
//
//    return await networkHelper.getData();
//  }

  Future<Weather> getLocationWeather({
    @required RequestedWeatherType type,
    bool useCelsius,
    double latitude,
    double longitude,
  }) async {
    String requestUrl;
    print('called');
    List<String> excludes = type == RequestedWeatherType.Hourly
        ? ["currently", "minutely", "daily", "alerts", "flags"]
        : type == RequestedWeatherType.Daily
            ? ["currently", "minutely", "hourly", "alerts", "flags"]
            : ["currently", "minutely", "alerts", "flags"];
    if (latitude != null && longitude != null) {
      requestUrl =
          '$darkSkyApiUrl/$kDarkSkyAPIKey/$latitude,$longitude?exclude=$excludes';
    } else {
      Location location = Location();
      await location.getLocation();
      requestUrl =
          '$darkSkyApiUrl/$kDarkSkyAPIKey/${location.latitude},${location.longitude}?exclude=$excludes';
    }

    NetworkHelper networkHelper = NetworkHelper(requestUrl);

    Map<String, dynamic> hourlyWeatherMap = await networkHelper.getData();
//

    return Weather.fromJson(hourlyWeatherMap);
  }

  String getMessage(String condition) {
    if (condition == 'clear-day') {
      return '1';
    } else if (condition == 'clear-night') {
      return '2';
    } else if (condition == 'rain') {
      return '3';
    } else if (condition == 'snow') {
      return '4';
    } else if (condition == 'sleet') {
      return '5';
    } else if (condition == 'wind') {
      return '6';
    } else if (condition == 'fog') {
      return '7';
    } else if (condition == 'cloudy') {
      return '8';
    } else if (condition == 'partly-cloudy-day') {
      return '9';
    } else if (condition == 'partly-cloudy-night') {
      return '10';
    } else {
      return '0';
    }
  }
}
