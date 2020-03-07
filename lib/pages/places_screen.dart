import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/google_nearby_place.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/pages/place_detail_screen.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/google_places.dart';
import 'package:book_my_weather/widgets/place_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class PlacesScreen extends StatefulWidget {
  static const String id = 'placesScreen';

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Future<List<GoogleNearByPlace>> getNearbyPlaces;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  String buildPhotoURL(String photoReference) {
    return '$kGPlacePhotoSearchURL?maxwidth=800&photoreference=$photoReference&key=$kGooglePlacesAPIKey';
  }

  @override
  Widget build(BuildContext context) {
//    final double width = MediaQuery.of(context).size.width;
//    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Places'),
          ),
          body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TabBar(
                  onTap: (int tabIndex) {
                    if (tabIndex == 1) {
                      GooglePlaces googlePlaces = GooglePlaces();
                      final index =
                          Provider.of<TripState>(context, listen: false)
                              .selectedIndex;
                      final trip = Provider.of<List<Trip>>(context,
                          listen: false)[index];
                      final latitude = trip.location.latitude;
                      final longitude = trip.location.longitude;

                      setState(() {
                        getNearbyPlaces = googlePlaces.getNearbyShoppingPlaces(
                          latitude: latitude,
                          longitude: longitude,
                        );
                      });
                    }
                  },
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.blueGrey,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 10.0,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      child: Text('Visiting'),
                    ),
                    Tab(
                      child: Text('Explore'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PlaceDetail.id);
                          },
                          child: PlaceCard(
                            placeCategory: 'Shopping',
                            placeName: 'Taipei 101',
//                            openNow: false,
//                            placeDesc:
//                                'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
                            placeImgPath: 'assets/images/taipei_101.jpg',
//                            placeOpenHour: '11:00am',
                            placeRating: 4.3,
                            placeReview: '(45,867)',
                            isExplore: false,
//                            currentTemp: '31',
//                            currentWeatherIconPath: 'assets/images/sunny.svg',
                          ),
                        ),
                        PlaceCard(
                          placeCategory: 'Shopping',
//                          openNow: false,
                          placeName: 'Taipei 101',
//                          placeDesc:
//                              'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
                          placeImgPath: 'assets/images/taipei_101.jpg',
//                          placeOpenHour: '11:00am',
                          placeRating: 4.3,
                          placeReview: '(45,867)',
                          isExplore: false,
//                          currentTemp: '31',
//                          currentWeatherIconPath: 'assets/images/sunny.svg',
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: getNearbyPlaces,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<GoogleNearByPlace>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SpinKitWave(
                            color: Colors.white,
                            size: 50.0,
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final place = snapshot.data[index];

                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 550),
                                          pageBuilder: (context, _, __) =>
                                              PlaceDetail(
                                            placeId: place.placeId,
                                            placeName: place.name,
                                            placeRating: place.rating,
                                            placeRatingTotals:
                                                place.ratingTotals,
                                            placeOpenNow: place.openNow,
                                            placeType: place.types[0]
                                                .split('_')
                                                .join(' '),
                                            placeAddress: place.address,
                                          ),
                                        ),
                                      );
                                    },
                                    child: place.openNow != null
                                        ? PlaceCard(
                                            placeCategory: place.types[0],
                                            placeName: place.name,
//                                            placeDesc:
//                                                'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
                                            placeImgPath: place.photos.length >
                                                    0
                                                ? buildPhotoURL(place.photos[0])
                                                : 'assets/images/no_image_found.jpg',
                                            placeRating: place.rating,
                                            placeReview:
                                                place.ratingTotals != null
                                                    ? '(${place.ratingTotals})'
                                                    : '(0)',
                                            openNow: place.openNow,
                                            isExplore: true,
                                            placeId: place.placeId,
                                          )
                                        : PlaceCard(
                                            placeCategory: place.types[0],
                                            placeName: place.name,
//                                            placeDesc:
//                                                'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
                                            placeImgPath: place.photos.length >
                                                    0
                                                ? buildPhotoURL(place.photos[0])
                                                : 'assets/images/no_image_found.jpg',
                                            placeRating: place.rating,
                                            placeReview:
                                                place.ratingTotals != null
                                                    ? '(${place.ratingTotals})'
                                                    : '(0)',
                                            isExplore: true,
                                            placeId: place.placeId,
                                          ));
                              });
                        }

                        if (snapshot.hasError)
                          return Text(
                            snapshot.error.toString(),
                            style: TextStyle(color: Colors.white),
                          );
                        return Container();
                      },
                    )
//                    GridView.count(
//                      primary: false,
////                      childAspectRatio: width / height < 0.5
////                          ? (width / 1.8) / (height / 2.6)
////                          : width / height > 0.5 && width / height < 0.6
////                          ? width / height
////                          : width / height > 0.6
////                          ? (width / 1.8) / (height / 2.2)
////                          : width / height,
//                      childAspectRatio: width / height < 0.5
//                          ? (width / 1.8) / (height / 2.6)
//                          : width / height,
//                      crossAxisCount: 2,
//                      children: <Widget>[
//                        GestureDetector(
//                          onTap: () {
//                            Navigator.pushNamed(context, PlaceDetail.id);
//                          },
//                          child: ExplorePlaceCardWidget(),
//                        ),
//                        ExplorePlaceCardWidget(),
//                        ExplorePlaceCardWidget(),
//                        ExplorePlaceCardWidget(),
//                        ExplorePlaceCardWidget(),
//                        ExplorePlaceCardWidget(),
//                        ExplorePlaceCardWidget(),
//                        ExplorePlaceCardWidget(),
//                      ],
//                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
