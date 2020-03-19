import 'package:book_my_weather/models/google_nearby_place.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/google_places.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:book_my_weather/widgets/explore_place_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceOverview extends StatefulWidget {
  const PlaceOverview({
    Key key,
    @required this.height,
    @required this.width,
    @required this.goToWeatherTab,
    @required this.address,
    @required this.phoneNumber,
    @required this.website,
    @required this.openingHours,
    @required this.googleUrl,
  }) : super(key: key);

  final double height;
  final double width;
  final Function goToWeatherTab;
  final String address;
  final String phoneNumber;
  final String website;
  final List<String> openingHours;
  final String googleUrl;

  @override
  _PlaceOverviewState createState() => _PlaceOverviewState();
}

class _PlaceOverviewState extends State<PlaceOverview> {
  Future<Weather> weatherForecast;
  Future<List<GoogleNearByPlace>> nearbyHotels;
  double containerHeight = 1000.0;
  WeatherModel weatherModel = WeatherModel();

  Future<Weather> getWeatherForecast() async {
    WeatherModel weatherModel = WeatherModel();
    Location location = Location();
    await location.getPlaceMarkFromAddress(address: widget.address);
    return await weatherModel.getLocationWeather(
      type: RequestedWeatherType.Daily,
      useCelsius: true,
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  Future<List<GoogleNearByPlace>> getNearbyHotels() async {
    GooglePlaces place = GooglePlaces();
    Location location = Location();
    await location.getPlaceMarkFromAddress(address: widget.address);
    return await place.getNearbyPlaces(
        latitude: location.latitude,
        longitude: location.longitude,
        type: 'lodging');
  }

  @override
  void initState() {
    super.initState();
    weatherForecast = getWeatherForecast();
    nearbyHotels = getNearbyHotels();
  }

  List<Widget> displayBusinessHours(List<String> hours) {
    return hours.map((hour) {
      return Text(
        hour,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w100,
        ),
      );
    }).toList();
  }

  Widget getDailyWeatherForecastIcon({String icon}) {
    return weatherModel.getWeatherIcon(
      condition: icon,
      iconColor: Color(0xFFFFA500),
      width: 30.0,
      height: 30.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 700,
        maxHeight: 1000,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                top: 16.0,
                bottom: 16.0,
              ),
              child: Text(
                'Information',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                bottom: 10.0,
              ),
              child: Text(
                widget.address ?? 'Address not available',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w100,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                bottom: 10.0,
              ),
              child: Text(
                widget.phoneNumber ?? 'Phone number not available',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                bottom: 10.0,
              ),
              child: InkWell(
                child: Text(
                  widget.website ?? 'Website not available',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                    color: Color(0XFF69A4FF),
                  ),
                ),
                onTap: () async {
                  if (await canLaunch(widget.website)) {
                    launch(widget.website);
                  }
                },
              ),
            ),
            SizedBox(
              height: 20.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Divider(
                  color: Colors.black26,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                top: 16.0,
//                bottom: 16.0,
              ),
              child: Text(
                'Business hours',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
              ),
              child:
                  widget.openingHours is List && widget.openingHours.length > 0
                      ? Container(
                          height: 200,
                          child: ListView(
                            padding: EdgeInsets.only(
                              top: 5.0,
                              left: 12.0,
                            ),
//                          crossAxisAlignment: CrossAxisAlignment.end,
                            children: displayBusinessHours(widget.openingHours),
                          ),
                        )
                      : Text(
                          'Not Available',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Divider(
                color: Colors.black26,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                top: 16.0,
                bottom: 16.0,
              ),
              child: Text(
                'Weather forecast',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.goToWeatherTab,
              child: FutureBuilder(
                future: weatherForecast,
                builder:
                    (BuildContext context, AsyncSnapshot<Weather> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitWave(
                      size: 30.0,
                      color: Colors.black,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final dailyWeather = snapshot.data.daily.data;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List<Widget>.generate(7, (index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${DateFormat('Md').format(DateTime.fromMillisecondsSinceEpoch(dailyWeather[index].time * 1000))}',
                              style: TextStyle(color: Colors.black),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 10),
//                          child: _SpinningSun(),
                              child: getDailyWeatherForecastIcon(
                                  icon: dailyWeather[index].icon),
                            ),
                            Text(
                              '${dailyWeather[index].temperatureHigh.toStringAsFixed(0)}º',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        );
                      }),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    );
                  }

                  return Container();
                },
              ),
            ),
            FutureBuilder(
              future: nearbyHotels,
              builder: (BuildContext context,
                  AsyncSnapshot<List<GoogleNearByPlace>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Divider(
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                            top: 16.0,
                            bottom: 16.0,
                          ),
                          child: Text(
                            'Hotels nearby',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                        SpinKitWave(
                          color: Colors.black,
                          size: 30.0,
                        )
                      ]);
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final nearbyHotels = snapshot.data;

                  if (nearbyHotels != null && snapshot.data.length > 0)
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Divider(
                                color: Colors.black26,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              top: 16.0,
                              bottom: 16.0,
                            ),
                            child: Text(
                              'Hotels nearby',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                          Container(
                            height: widget.height < 600 ? 220 : 250,
                            child: ListView(
                              itemExtent: widget.width / 2.5,
                              scrollDirection: Axis.horizontal,
                              children: List<Widget>.generate(
                                nearbyHotels.length,
                                (index) => GestureDetector(
                                  onTap: () async {
                                    final url =
                                        'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=name&place_id=${nearbyHotels[index].placeId}';
                                    NetworkHelper networkHelper =
                                        NetworkHelper(url);

                                    try {
                                      Map<String, dynamic> result =
                                          await networkHelper.getData();
                                      final name = result['result']['name'];
                                      MapsLauncher.launchQuery(name);
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  child: ExplorePlaceCardWidget(
                                    name: nearbyHotels[index].name,
                                    placeId: nearbyHotels[index].placeId,
                                    openNow: nearbyHotels[index].openNow,
                                    rating: nearbyHotels[index].rating,
                                    ratingTotals:
                                        nearbyHotels[index].ratingTotals,
                                    type: nearbyHotels[index]
                                        .types[0]
                                        .split('_')
                                        .join(' '),
                                    photo: nearbyHotels[index].photos.length > 0
                                        ? buildPhotoURL(
                                            nearbyHotels[index].photos[0])
                                        : 'assets/images/no_image_found.jpg',
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]);
                }

                if (snapshot.hasError) {
                  return Text(
                    snapshot.error.toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
