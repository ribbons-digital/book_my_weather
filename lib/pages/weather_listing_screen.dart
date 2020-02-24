import 'dart:async';

import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/pages/search_place_screen.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/widgets/weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeatherListingScreen extends StatefulWidget {
  static const String id = 'home';
  final List<Place> places;
  final Setting setting;

  WeatherListingScreen({@required this.places, this.setting});

  @override
  _WeatherListingScreenState createState() => _WeatherListingScreenState();
}

class _WeatherListingScreenState extends State<WeatherListingScreen> {
  PageController _pageController;

  int currentPage = 0;
  String placeName = '';

  Future<Weather> hourlyWeather;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: currentPage,
      keepPage: false,
    );
    hourlyWeather = getWeather();
  }

  Future<Weather> getWeather() async {
    WeatherModel weather = WeatherModel();

    if (widget.places.length > 0) {
      setState(() {
        placeName = widget.places[0].address;
      });
      return await weather.getLocationWeather(
        type: RequestedWeatherType.Both,
        useCelsius: true,
        latitude: widget.places[0].latitude,
        longitude: widget.places[0].longitude,
      );
    } else {
      Location location = Location();
      await location.getLocation();

      await location.getPlaceMarkFromCoordinates(
          lat: location.latitude, lng: location.longitude);

      setState(() {
        placeName = location.placeMark[0].locality;
      });
      Weather currentPlaceWeather = await weather.getLocationWeather(
        type: RequestedWeatherType.Both,
        useCelsius: true,
        latitude: location.latitude,
        longitude: location.longitude,
      );

      _addPlace(Place(
        name: location.placeMark[0].name,
        address: location.placeMark[0].locality,
        latitude: location.latitude,
        longitude: location.longitude,
        weather: currentPlaceWeather,
      ));

      return currentPlaceWeather;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _addPlace(Place newPlace) {
    Provider.of<PlaceData>(context, listen: false).addPlace(newPlace);
  }

  void _updatePlaceWeather(int index, Weather updatedWeather) {
    Provider.of<PlaceData>(context, listen: false)
        .updatePlaceWeather(index, updatedWeather);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (Provider.of<Setting>(context) != null) {
      WeatherModel weather = WeatherModel();
      final tempPlaces = Provider.of<Setting>(context, listen: false).places;
      setState(() {
        placeName = tempPlaces[0].address;
      });

      Weather placeWeather = await weather.getLocationWeather(
        type: RequestedWeatherType.Both,
        useCelsius: true,
        latitude: tempPlaces[0].latitude,
        longitude: tempPlaces[0].longitude,
      );

      List<Place> places = [];
      for (var i = 0; i <= tempPlaces.length - 1; i++) {
        places.add(Place(
          name: tempPlaces[i].name,
          address: tempPlaces[i].address,
          latitude: tempPlaces[i].latitude,
          longitude: tempPlaces[i].longitude,
          weather: placeWeather,
        ));
      }

      Provider.of<PlaceData>(context, listen: false).updatePlaces(places);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

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
                IconButton(
                  padding: EdgeInsets.only(right: 16.0),
                  icon: Icon(Icons.my_location),
                  onPressed: () {
                    final newPlace = Place(
                      address: 'Taipei, Taiwan',
                      name: 'Taipei City',
                      latitude: 25.105497,
                      longitude: 121.597366,
                    );

                    db.updatePlaces('9g6UjX6R9CP5KEc9PQ1r', newPlace);
                  },
                )
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
              if (snapshot.hasData) {
                String date = DateFormat('EEE, MMM d')
                    .format(DateTime.fromMillisecondsSinceEpoch(
                        snapshot.data.daily.data[0].time * 1000))
                    .toString();
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
                              widget.places[currentPage].address,
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
                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                          controller: _pageController,
                          itemCount: widget.places.length,
                          onPageChanged: (int index) async {
                            setState(() {
                              currentPage = index;
                            });

                            final place =
                                Provider.of<PlaceData>(context, listen: false).places[index];

                            WeatherModel weather = WeatherModel();
                            Weather updatedWeather =
                                await weather.getLocationWeather(
                              type: RequestedWeatherType.Both,
                              useCelsius: true,
                              latitude: place.latitude,
                              longitude: place.longitude,
                            );

                            _updatePlaceWeather(index, updatedWeather);
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
