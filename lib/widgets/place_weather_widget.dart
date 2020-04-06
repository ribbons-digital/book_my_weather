import 'package:book_my_weather/app_localizations.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/setting.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/widgets/daily_weather_widget.dart';
import 'package:book_my_weather/widgets/hourly_weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlaceWeather extends StatefulWidget {
  final String address;

  PlaceWeather({this.address});

  @override
  _PlaceWeatherState createState() => _PlaceWeatherState();
}

class _PlaceWeatherState extends State<PlaceWeather> {
  bool isHourly = true;
  Future<Weather> getWeather;

  Future<Weather> getWeatherForecast() async {
    WeatherModel weatherModel = WeatherModel();
    Location location = Location();
    SettingModel settingModel = SettingModel();
    final currentSetting = settingModel.getCurrentSetting();
    await location.getPlaceMarkFromAddress(address: widget.address);
    return await weatherModel.getLocationWeather(
      type: RequestedWeatherType.All,
      useCelsius: currentSetting.useCelsius,
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  void switchWeatherView() {
    setState(() {
      isHourly = !isHourly;
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather = getWeatherForecast();
  }

  @override
  Widget build(BuildContext context) {
    final String hourlyString = AppLocalizations.of(context)
        .translate('place_detail_screen_place_weather_dropdown_option_1');

    final String dailyString = AppLocalizations.of(context)
        .translate('place_detail_screen_place_weather_dropdown_option_2');

    return FutureBuilder(
      future: getWeather,
      builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: SpinKitWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Text(
              snapshot.error.toString(),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final hourlyWeatherData = snapshot.data.hourly.data;
          final dailyWeatherData = snapshot.data.daily.data;

          return SliverList(
            delegate: SliverChildListDelegate(
              List.generate(isHourly ? 24 : 7, (i) {
                if (i == 0) {
                  return Theme(
                    data: ThemeData(
                      canvasColor: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        top: 8.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      child: DropdownButton(
                        value: isHourly ? hourlyString : dailyString,
                        elevation: 16,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                          fontSize: 20.0,
                        ),
                        items: <String>[hourlyString, dailyString]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            newValue == hourlyString
                                ? isHourly = true
                                : isHourly = false;
                          });
                        },
                      ),
                    ),
                  );
                }
                return isHourly
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          bottom: 16.0,
                        ),
                        child: HourlyWeatherWidget(
                          hourIndex: i,
                          hourlyWeatherData: hourlyWeatherData,
                          hourTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontSize: 24.0,
                          ),
                          weatherBoxBackgroundColor: Colors.white,
                          tempTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontSize: 24.0,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DailyWeather(
                          dayIndex: i,
                          dailyWeatherData: dailyWeatherData,
                          tempRangeTextStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          weatherBoxBackgroundColor: Colors.white,
                          dateTextStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      );
              }),
            ),
          );
        }

        return Container();
      },
    );
  }
}
