import 'dart:async';

import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/pages/search_place_screen.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/setting.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:book_my_weather/widgets/message_handler.dart';
import 'package:book_my_weather/widgets/weather_widget.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WeatherListingScreen extends StatefulWidget {
  static const String id = 'home';

  @override
  _WeatherListingScreenState createState() => _WeatherListingScreenState();
}

class _WeatherListingScreenState extends State<WeatherListingScreen>
    with WidgetsBindingObserver {
  PageController _pageController;
  int currentPage = 0;
  String placeName = '';
  Timer _throttle;
  Future<Weather> hourlyWeather;
  final settingsBox = Hive.box('settings');
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: currentPage,
      keepPage: false,
    );
    hourlyWeather = getWeather();
  }

  Future<Weather> getWeather() async {
    WeatherModel weather = WeatherModel();
    Weather currentPlaceWeather;

    Location location = Location();
    await location.getLocation();

    await location.getPlaceMarkFromCoordinates(
      lat: location.latitude,
      lng: location.longitude,
    );

    setState(() {
      placeName = location.placeMark[0].locality;
    });

    if (settingsBox.length == 0) {
      currentPlaceWeather = await weather.getLocationWeather(
        type: RequestedWeatherType.All,
        useCelsius: true,
        latitude: location.latitude,
        longitude: location.longitude,
      );

      final newPlace = Place(
        name: location.placeMark[0].name,
        address: location.placeMark[0].locality,
        latitude: location.latitude,
        longitude: location.longitude,
        weather: currentPlaceWeather,
      );

      Setting newSetting = Setting(
        useCelsius: true,
        places: [newPlace],
        baseSymbol: getCurrencySymbol(context),
      );

      initializeSetting(newSetting);
    } else {
      SettingModel settingModel = SettingModel();
      final currentSetting = settingModel.getCurrentSetting();
      currentPlaceWeather = await weather.getLocationWeather(
        type: RequestedWeatherType.All,
        useCelsius: currentSetting.useCelsius,
        latitude: location.latitude,
        longitude: location.longitude,
      );
      final updatedPlace = Place(
        name: location.placeMark[0].name,
        address: location.placeMark[0].locality,
        latitude: location.latitude,
        longitude: location.longitude,
        weather: currentPlaceWeather,
      );

      updatePlaceInSetting(0, updatedPlace);
    }

    return currentPlaceWeather;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
  }

  void _updatePlaceWeather(int index, Weather updatedWeather) {
    Setting setting = (settingsBox.getAt(0) as Setting);
    setting.places[index].weather = updatedWeather;
    settingsBox.putAt(0, setting);
  }

  Color getAqiColor() {
    final places = (settingsBox.get(0) as Setting).places;
    final aqi = places[currentPage].weather.aqi;

    if (aqi >= 0 && aqi <= 50) {
      return Colors.green;
    }

    if (aqi >= 51 && aqi <= 100) {
      return Colors.yellow;
    }

    if (aqi >= 101 && aqi <= 150) {
      return Colors.orange;
    }

    if (aqi >= 151 && aqi <= 200) {
      return Colors.red;
    }

    if (aqi >= 201 && aqi <= 300) {
      return Colors.purple;
    }

    if (aqi >= 301 && aqi <= 500) {
      return Color(0XFF800000);
    }

    return Colors.white;
  }

  String getAqiEmoji() {
    final places = (settingsBox.get(0) as Setting).places;
    final aqi = places[currentPage].weather.aqi;

    if (aqi >= 0 && aqi <= 50) {
      return '🙂';
    }

    if (aqi >= 51 && aqi <= 100) {
      return '😐';
    }

    if (aqi >= 101 && aqi <= 150) {
      return '☹️';
    }

    if (aqi >= 151 && aqi <= 200) {
      return '😷';
    }

    if (aqi >= 201 && aqi <= 300) {
      return '😱';
    }

    if (aqi >= 301 && aqi <= 500) {
      return '😵';
    }

    return '🤪';
  }

  void displayAqiGuide(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            title: Text('Air Quality Guide'),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                    ),
                    title: Text('0 ~ 50'),
                    subtitle: Text('Good'),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.yellow,
                    ),
                    title: Text('51 ~ 100'),
                    subtitle: Text('Moderate'),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                    ),
                    title: Text('101 ~ 150'),
                    subtitle: Text('Unhealthy for sensitive groups'),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                    ),
                    title: Text('151 ~ 200'),
                    subtitle: Text('Unhealthy'),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                    ),
                    title: Text('201 ~ 300'),
                    subtitle: Text('Very unhealthy'),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0XFF800000),
                    ),
                    title: Text('301 ~ 500'),
                    subtitle: Text('Hazardous'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget _buildCircleIndicator() {
    if (settingsBox != null && settingsBox.length > 0) {
      final places = (settingsBox.get(0) as Setting).places;
      if (places.length > 1) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CirclePageIndicator(
              itemCount: places.length,
              currentPageNotifier: _currentPageNotifier,
            ),
          ),
        );
      } else {
        return Container();
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.arrow_back_ios),
        actions: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Txt(
                    'Weather',
                    style: kScreenTitleTextStyle,
                  ),
                ),
                IconButton(
//                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    Icons.search,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, SearchPlaceScreen.id);
                  },
                ),

//                if (currentPage == 0)
//                  IconButton(
//                      padding: EdgeInsets.only(right: 16.0),
//                      icon: Icon(Icons.refresh),
//                      onPressed: () async {
////                      await getWeather();
//                        HttpsCallable callable = CloudFunctions.instance
//                            .getHttpsCallable(functionName: 'sendNotification');
//                        await callable();
////                        _auth.signOut();
//                      })
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FutureBuilder<Weather>(
            future: hourlyWeather,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  (snapshot.connectionState == ConnectionState.none ||
                      snapshot.connectionState == ConnectionState.done) &&
                  snapshot.data.daily.data.length > 0 &&
                  snapshot.data.hourly.data.length > 0) {
                String date = DateFormat('EEE, MMM d')
                    .format(DateTime.fromMillisecondsSinceEpoch(
                        snapshot.data.daily.data[0].time * 1000))
                    .toString();
                final places = (settingsBox.get(0) as Setting).places;

                final ParentStyle parentStyle = ParentStyle()
                  ..padding(
                    left: 20.0,
                    top: 8.0,
                    right: 20.0,
                  );
                final TxtStyle screenTextStyle = TxtStyle()
                  ..textColor(
                    Colors.white,
                  )
                  ..fontSize(
                    50.0,
                  )
                  ..fontWeight(
                    FontWeight.w100,
                  );
                final TxtStyle aqiTextStyle = screenTextStyle.clone()
                  ..textColor(getAqiColor())
                  ..fontWeight(FontWeight.w300)
                  ..fontSize(
                    35.0,
                  );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MessageHandler(),
                    Parent(
                      style: parentStyle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Txt(
                              places[currentPage].address,
                              style: screenTextStyle,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          if (height > 600)
                            Txt(
                              date,
                              style: screenTextStyle.clone()
                                ..fontSize(
                                  20.0,
                                ),
                            ),
                          if (height > 600)
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  displayAqiGuide(context);
                                },
                                child: CircularPercentIndicator(
                                  radius: 90.0,
                                  lineWidth: 15.0,
                                  animation: true,
                                  percent:
                                      places[currentPage].weather.aqi / 500,
                                  center: new Text(
                                    places[currentPage]
                                        .weather
                                        .aqi
                                        .toStringAsFixed(0),
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: getAqiColor(),
                                    ),
                                  ),
                                  footer: new Text(
                                    "Air Quality",
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: getAqiColor(),
                                ),
                              ),
                            ),
                          if (height > 600)
                            SizedBox(
                              height: 18.0,
                            ),
                          if (height < 600)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Txt(
                                  date,
                                  style: screenTextStyle.clone()
                                    ..fontSize(25.0),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    displayAqiGuide(context);
                                  },
                                  child: CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 7.0,
                                    animation: true,
                                    percent:
                                        places[currentPage].weather.aqi / 500,
                                    center: new Text(
                                      places[currentPage]
                                          .weather
                                          .aqi
                                          .toStringAsFixed(0),
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: getAqiColor(),
                                      ),
                                    ),
                                    footer: new Text(
                                      "Air Quality",
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: getAqiColor(),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                          controller: _pageController,
                          itemCount: places.length,
                          physics: BouncingScrollPhysics(),
                          onPageChanged: (int index) async {
                            final place = places[index];
                            await _handlePageChange(index, place);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return WeatherWidget(
                              placeIndex: index,
                            );
                          }),
                    ),
                    _buildCircleIndicator(),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text(
                  '${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                );
              }
              return SpinKitWave(
                color: Colors.white,
                size: 50.0,
              );
            },
          ),
        ),
      ),
    );
  }

  Future _handlePageChange(int index, Place place) async {
    _currentPageNotifier.value = index;

    setState(() {
      currentPage = index;
    });

    if (_throttle?.isActive ?? false) _throttle.cancel();
    _throttle = Timer(const Duration(milliseconds: 800), () async {
      WeatherModel weather = WeatherModel();
      SettingModel settingModel = SettingModel();
      final currentSetting = settingModel.getCurrentSetting();
      Weather updatedWeather = await weather.getLocationWeather(
        type: RequestedWeatherType.All,
        useCelsius: currentSetting.useCelsius,
        latitude: place.latitude,
        longitude: place.longitude,
      );

      _updatePlaceWeather(index, updatedWeather);
    });
  }
}
