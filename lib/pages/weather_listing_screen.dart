import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/models/weather.dart';
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

  WeatherListingScreen({@required this.places});

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
        placeName = widget.places[0].name;
      });
      return await weather.getLocationWeather(
        type: RequestedWeatherType.Both,
        latitude: widget.places[0].latitude,
        longitude: widget.places[0].longitude,
      );
    } else {
      Location location = Location();
      await location.getLocation();

      await location.getPlaceMarkFromCoordinates(
          lat: location.latitude, lng: location.longitude);

      setState(() {
        placeName = location.placeMark[0].name;
      });
      Weather currentPlaceWeather = await weather.getLocationWeather(
        type: RequestedWeatherType.Both,
        latitude: location.latitude,
        longitude: location.longitude,
      );

      return currentPlaceWeather;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Place> places = Provider.of<PlaceData>(context).places;

    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.arrow_back_ios),
        actions: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.only(right: 16.0),
                  icon: Icon(Icons.my_location),
                  onPressed: () {},
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
                              placeName,
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
                      child: PageView(
                        controller: _pageController,
                        children: <Widget>[
                          WeatherWidget(),
                          WeatherWidget(),
                        ],
                      ),
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
