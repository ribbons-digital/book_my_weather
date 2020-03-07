import 'package:book_my_weather/models/google_nearby_place.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/services/google_places.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:book_my_weather/widgets/explore_place_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//class PlaceDetailWidget extends StatelessWidget {
//  const PlaceDetailWidget({
//    Key key,
//    @required TabController tabController,
//  })  : _tabController = tabController,
//        super(key: key);
//
//  final TabController _tabController;
//
//  @override
//  Widget build(BuildContext context) {
////    final height = MediaQuery.of(context).size.height;
////    final width = MediaQuery.of(context).size.width;
//
//    return Container(
//      height: 1350,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          ListTile(
//            title: Text('Taipei 101'),
//            subtitle: Text('Shopping'),
//          ),
//          Padding(
//            padding: EdgeInsets.only(left: 15.0),
//            child: Row(
//              children: <Widget>[
//                Text(
//                  '4.5',
//                  style: TextStyle(
//                    color: Colors.black,
//                    fontSize: 15,
//                  ),
//                ),
//                SmoothStarRating(
//                  allowHalfRating: true,
//                  onRatingChanged: (v) {
////                              rating = v;
////                              setState(() {});
//                  },
//                  starCount: 5,
//                  rating: 4.3,
//                  size: 18.0,
//                  filledIconData: Icons.star,
//                  halfFilledIconData: Icons.star_half,
//                  color: Color(0XFF69A4FF),
//                  borderColor: Color(0XFF69A4FF),
//                  spacing: 0.0,
//                ),
//                Text(
//                  '(45,867)',
//                  style: TextStyle(
//                    color: Colors.black,
//                    fontSize: 15,
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 8.0),
//            child: Text(
//              'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
//              style: TextStyle(
//                fontSize: 16.0,
//              ),
//              maxLines: 3,
//              overflow: TextOverflow.ellipsis,
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
//            child: RichText(
//              text: TextSpan(
//                children: [
//                  TextSpan(
//                    text: 'Closed - ',
//                    style: TextStyle(
//                      color: Colors.red,
//                      fontSize: 15,
//                    ),
//                  ),
//                  TextSpan(
//                    text: 'Opens 11am',
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 15,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//          Container(
//            width: double.infinity,
//            height: 40.0,
//            padding: EdgeInsets.only(left: 15.0),
//            child: ListView(
//              scrollDirection: Axis.horizontal,
//              children: <Widget>[
//                FlatButton(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(18.0),
//                    side: BorderSide(
//                      color: Color(0XFF69A4FF),
//                    ),
//                  ),
//                  child: Row(
//                    children: <Widget>[
//                      Icon(
//                        Icons.phone,
//                        color: Color(0XFF69A4FF),
//                      ),
////                      SvgPicture.asset(
////                        'assets/images/note_solid.svg',
////                        width: 14.0,
////                        height: 16.0,
////                        color: Color(0XFF69A4FF),
////                      ),
//                      SizedBox(
//                        width: 5.0,
//                      ),
//                      Text(
//                        'Call',
//                        style: TextStyle(
//                          color: Color(0XFF69A4FF),
//                        ),
//                      ),
//                    ],
//                  ),
//                  onPressed: () {},
//                ),
//                SizedBox(
//                  width: 20.0,
//                ),
//                FlatButton(
//                  child: Row(
//                    children: <Widget>[
//                      Icon(
//                        Icons.share,
//                        color: Color(0XFF69A4FF),
//                      ),
//                      SizedBox(
//                        width: 5.0,
//                      ),
//                      Text(
//                        'Share',
//                        style: TextStyle(
//                          color: Color(0XFF69A4FF),
//                        ),
//                      ),
//                    ],
//                  ),
//                  shape: RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(18.0),
//                    side: BorderSide(
//                      color: Color(0XFF69A4FF),
//                    ),
//                  ),
//                  onPressed: () {},
//                ),
//                SizedBox(
//                  width: 20.0,
//                ),
//                FlatButton(
//                  child: Row(
//                    children: <Widget>[
//                      Icon(
//                        Icons.bookmark,
//                        color: Color(0XFF69A4FF),
//                      ),
//                      SizedBox(
//                        width: 5.0,
//                      ),
//                      Text(
//                        'Save',
//                        style: TextStyle(
//                          color: Color(0XFF69A4FF),
//                        ),
//                      ),
//                    ],
//                  ),
//                  shape: RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(18.0),
//                    side: BorderSide(
//                      color: Color(0XFF69A4FF),
//                    ),
//                  ),
//                  onPressed: () {},
//                ),
//              ],
//            ),
//          ),
//          SizedBox(
//            height: 20.0,
//            child: Padding(
//              padding: const EdgeInsets.symmetric(
//                horizontal: 10.0,
//              ),
//              child: Divider(
//                color: Colors.black26,
//              ),
//            ),
//          ),
//          Center(
//            child: TabBar(
//              isScrollable: true,
//              labelColor: Color(0XFF69A4FF),
//              unselectedLabelColor: Colors.black26,
//              indicatorSize: TabBarIndicatorSize.label,
//              indicatorWeight: 10.0,
//              indicatorColor: Color(0XFF69A4FF),
//              indicatorPadding: EdgeInsets.symmetric(horizontal: 8.0),
//              labelStyle: TextStyle(
//                fontWeight: FontWeight.bold,
//                fontSize: 15.0,
//              ),
//              controller: _tabController,
//              tabs: <Widget>[
//                Tab(
//                  child: Text('Overview'),
//                ),
//                Tab(
//                  child: Text('Weather'),
//                ),
//                Tab(
//                  child: Text('Photos'),
//                ),
//                Tab(
//                  child: Text('Notes'),
//                ),
//              ],
//            ),
//          ),
//          Expanded(
//            child: TabBarView(
//              controller: _tabController,
//              children: <Widget>[
////                PlaceOverview(height: height, width: width,),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Expanded(
//                      child: Column(
//                        children: List.generate(5, (i) {
//                          return HourlyWeatherWidget(
//                            hour: '8am',
//                            temperature: '31',
//                            weatherIconPath: 'assets/images/sunny.png',
//                            hourIndex: i,
//                          );
//                        }),
//                      ),
//                    )
//                  ],
//                ),
//                Text('3'),
//                Text('4'),
//              ],
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}

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

  @override
  Widget build(BuildContext context) {
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

    return Container(
//      height: containerHeight,
      constraints: BoxConstraints(
        minHeight: 800.0,
        maxHeight: 1000.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              widget.address,
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
              widget.phoneNumber,
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
                widget.website,
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
              bottom: 16.0,
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: displayBusinessHours(widget.openingHours)),
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
              builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
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
                    children: List<Widget>.generate(
                      7,
                      (index) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${DateFormat('Md').format(DateTime.fromMillisecondsSinceEpoch(dailyWeather[index].time * 1000))}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 10),
//                          child: _SpinningSun(),
                            child: Image.asset(
                              'assets/images/sunny.png',
                              scale: 3.5,
                            ),
                          ),
                          Text(
                            '${dailyWeather[index].temperatureHigh.toStringAsFixed(0)}º',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
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

                if (snapshot.data.length > 0)
                  return Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List<Widget>.generate(
                                15,
                                (index) => AspectRatio(
                                  aspectRatio: widget.height < 600
                                      ? widget.width / widget.height
                                      : (widget.width * 1.1) / widget.height,
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
                                    photo: buildPhotoURL(
                                        nearbyHotels[index].photos[0]),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
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
        ],
      ),
    );
  }
}
