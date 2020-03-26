import 'dart:async';

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
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class WeatherListingScreen extends StatefulWidget {
  static const String id = 'home';
//  final List<Place> places;
//  final String deviceId;

//  WeatherListingScreen({@required this.places, @required this.deviceId});

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

//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) async {
//    super.didChangeAppLifecycleState(state);
//    if (state == AppLifecycleState.paused) {
//      HttpsCallable callable = CloudFunctions.instance
//          .getHttpsCallable(functionName: 'sendNotification');
//      await callable();
//    }
//  }

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

//  @override
//  void didChangeDependencies() async {
//    super.didChangeDependencies();
////    if (_notification != null && _notification.index == 0) {
////      print(_notification.index);
////      await getWeather();
////    }
//
//    if (Provider.of<Setting>(context, listen: false) != null &&
//        widget.places.length >
//            Provider.of<Setting>(context, listen: false).places.length &&
//        widget.places.length > 1) {
//      final db = DatabaseService();
//
//      final tempPlaces = widget.places;
//      setState(() {
//        placeName = tempPlaces[0].address;
//      });
//
//      final docId = Provider.of<Setting>(context, listen: false).id;
//
//      db.updatePlaces(
//          docId,
//          Place(
//            name: tempPlaces[tempPlaces.length - 1].name,
//            address: tempPlaces[tempPlaces.length - 1].name == ''
//                ? tempPlaces[tempPlaces.length - 1].address
//                : tempPlaces[tempPlaces.length - 1].name,
//            latitude: tempPlaces[tempPlaces.length - 1].latitude,
//            longitude: tempPlaces[tempPlaces.length - 1].longitude,
//          ));
//    }
//
//    if (Provider.of<Setting>(context, listen: false) != null &&
//        widget.places.length <
//            Provider.of<Setting>(context, listen: false).places.length) {
//      WeatherModel weather = WeatherModel();
//      final tempPlaces = Provider.of<Setting>(context, listen: false).places;
//      Weather placeWeather = await weather.getLocationWeather(
//        type: RequestedWeatherType.All,
//        useCelsius: true,
//        latitude: tempPlaces[0].latitude,
//        longitude: tempPlaces[0].longitude,
//      );
//
//      List<Place> places = [];
//
//      if (widget.places.length > 0) {
//        places = widget.places[0].name == tempPlaces[0].name
//            ? []
//            : List.from(widget.places);
//      }
//      for (var i = 0; i <= tempPlaces.length - 1; i++) {
//        places.add(Place(
//          name: tempPlaces[i].name,
//          address: tempPlaces[i].address,
//          latitude: tempPlaces[i].latitude,
//          longitude: tempPlaces[i].longitude,
//          weather: placeWeather,
//        ));
//      }
//
//      Provider.of<PlaceData>(context, listen: false).updatePlaces(places);
//    }
//
//    if (Provider.of<Setting>(context, listen: false) != null &&
//        Provider.of<Setting>(context, listen: false).places.length == 0) {
//      if (widget.places.length > 0) {
//        final place = Place(
//          name: widget.places[0].name,
//          address: widget.places[0].address,
//          latitude: widget.places[0].latitude,
//          longitude: widget.places[0].longitude,
//        );
//        final db = DatabaseService();
//        db.addNewSetting(widget.deviceId, place);
//      }
//    }
//  }

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
                Expanded(
                  child: IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Icon(
                      Icons.search,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, SearchPlaceScreen.id);
                    },
                  ),
                ),
                MessageHandler(),
                if (currentPage == 0)
                  IconButton(
                      padding: EdgeInsets.only(right: 16.0),
                      icon: Icon(Icons.refresh),
                      onPressed: () async {
//                      await getWeather();
                        HttpsCallable callable = CloudFunctions.instance
                            .getHttpsCallable(functionName: 'sendNotification');
                        await callable();
//                        _auth.signOut();
                      })
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 8.0,
                        right: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              places[currentPage].address,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                                fontSize: 50,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          if (height > 600)
                            Text(
                              date,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                                fontSize: 30,
                              ),
                            ),
                          if (height > 600)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    places[currentPage]
                                            .weather
                                            .aqi
                                            .toStringAsFixed(0) +
                                        ' ' +
                                        getAqiEmoji(),
                                    style: TextStyle(
                                      color: getAqiColor(),
                                      fontWeight: FontWeight.w300,
                                      fontSize: 45,
                                    ),
                                  ),
                                  Text(
                                    'Air Quality Index',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
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
                                Text(
                                  date,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 30,
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      places[currentPage]
                                              .weather
                                              .aqi
                                              .toStringAsFixed(0) +
                                          ' ' +
                                          getAqiEmoji(),
                                      style: TextStyle(
                                        color: getAqiColor(),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      'Air Quality Index',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
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
                          onPageChanged: (int index) async {
                            setState(() {
                              currentPage = index;
                            });

                            if (_throttle?.isActive ?? false)
                              _throttle.cancel();
                            _throttle = Timer(const Duration(milliseconds: 800),
                                () async {
                              final place = places[index];

                              WeatherModel weather = WeatherModel();
                              SettingModel settingModel = SettingModel();
                              final currentSetting =
                                  settingModel.getCurrentSetting();
                              Weather updatedWeather =
                                  await weather.getLocationWeather(
                                type: RequestedWeatherType.All,
                                useCelsius: currentSetting.useCelsius,
                                latitude: place.latitude,
                                longitude: place.longitude,
                              );

                              _updatePlaceWeather(index, updatedWeather);
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return WeatherWidget(placeIndex: index);
                          }),
                    ),
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
}
