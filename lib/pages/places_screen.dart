import 'dart:async';

import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/google_nearby_place.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/pages/place_detail_screen.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/google_places.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:book_my_weather/widgets/place_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum PlaceType { General, Food, Hotel }

class PlacesScreen extends StatefulWidget {
  static const String id = 'placesScreen';
  final Trip trip;
  final PlaceType placeType;

  PlacesScreen({@required this.trip, this.placeType});

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen>
    with SingleTickerProviderStateMixin {
  // TabController _tabController;
  Future<List<GoogleNearByPlace>> getNearbyPlaces;
  NearbySearchType selectedSearchType;

  static const _iOSAdUnitID = kAdMobIosAdUnit;
  static const _androidAdUnitId = kAdMobAndroidAdUnit;

  final _controller = NativeAdmobController();

  Future<List<GoogleNearByPlace>> getPlaces(
      {NearbySearchType searchType}) async {
    final type = getSearchTypeString(searchType);
    GooglePlaces googlePlaces = GooglePlaces();

    final latitude = widget.trip.location.latitude;
    final longitude = widget.trip.location.longitude;

    return await googlePlaces.getNearbyPlaces(
      latitude: latitude,
      longitude: longitude,
      type: type,
    );
  }

  void getDefaultSearchType() {
    if (widget.placeType == PlaceType.General) {
      setState(() {
        selectedSearchType = NearbySearchType.ShoppingMall;
      });
    }

    if (widget.placeType == PlaceType.Food) {
      setState(() {
        selectedSearchType = NearbySearchType.Restaurant;
      });
    }
    if (widget.placeType == PlaceType.Hotel) {
      setState(() {
        selectedSearchType = NearbySearchType.Lodging;
      });
    }
  }

  Color displaySelectedColor(NearbySearchType searchType) {
    return selectedSearchType == searchType ? Colors.white : Colors.black;
  }

  @override
  void initState() {
    // _tabController = TabController(length: 1, vsync: this);
    getDefaultSearchType();
    getNearbyPlaces = getPlaces(searchType: selectedSearchType);
    super.initState();
  }

  String buildPhotoURL(String photoReference) {
    return '$kGPlacePhotoSearchURL?maxwidth=800&photoreference=$photoReference&key=$kGooglePlacesAPIKey';
  }

  void optionPressed(NearbySearchType searchType) {
    setState(() {
      getNearbyPlaces = getPlaces(searchType: searchType);
      selectedSearchType = searchType;
    });
  }

  ListView searchTypeOptions() {
    if (widget.placeType == PlaceType.General)
      return ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _PlaceSearchTypeOption(
            searchType: NearbySearchType.ShoppingMall,
            onPress: () {
              optionPressed(NearbySearchType.ShoppingMall);
            },
            displayColor: displaySelectedColor(NearbySearchType.ShoppingMall),
          ),
          SizedBox(
            width: 8.0,
          ),
          _PlaceSearchTypeOption(
            searchType: NearbySearchType.ArtGallery,
            onPress: () {
              optionPressed(NearbySearchType.ArtGallery);
            },
            displayColor: displaySelectedColor(NearbySearchType.ArtGallery),
          ),
          SizedBox(
            width: 8.0,
          ),
          _PlaceSearchTypeOption(
            searchType: NearbySearchType.ATM,
            onPress: () {
              optionPressed(NearbySearchType.ATM);
            },
            displayColor: displaySelectedColor(NearbySearchType.ATM),
          ),
          SizedBox(
            width: 8.0,
          ),
          _PlaceSearchTypeOption(
            searchType: NearbySearchType.Bakery,
            onPress: () {
              optionPressed(NearbySearchType.Bakery);
            },
            displayColor: displaySelectedColor(NearbySearchType.Bakery),
          ),
          SizedBox(
            width: 8.0,
          ),
          _PlaceSearchTypeOption(
            searchType: NearbySearchType.Bank,
            onPress: () {
              optionPressed(NearbySearchType.Bank);
            },
            displayColor: displaySelectedColor(NearbySearchType.Bank),
          ),
          SizedBox(
            width: 8.0,
          ),
          _PlaceSearchTypeOption(
            searchType: NearbySearchType.Bar,
            onPress: () {
              optionPressed(NearbySearchType.Bar);
            },
            displayColor: displaySelectedColor(NearbySearchType.Bar),
          ),
          SizedBox(
            width: 8.0,
          ),
          _PlaceSearchTypeOption(
            searchType: NearbySearchType.BookStore,
            onPress: () {
              optionPressed(NearbySearchType.BookStore);
            },
            displayColor: displaySelectedColor(NearbySearchType.BookStore),
          ),
        ],
      );

    if (widget.placeType == PlaceType.Food)
      return ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _PlaceSearchTypeOption(
            searchType: NearbySearchType.Restaurant,
            onPress: () {
              optionPressed(NearbySearchType.Restaurant);
            },
            displayColor: displaySelectedColor(NearbySearchType.Restaurant),
          ),
          SizedBox(
            width: 8.0,
          ),
          _PlaceSearchTypeOption(
            searchType: NearbySearchType.Cafe,
            onPress: () {
              optionPressed(NearbySearchType.Cafe);
            },
            displayColor: displaySelectedColor(NearbySearchType.Cafe),
          ),
        ],
      );

    return ListView();
  }

  @override
  void dispose() {
    super.dispose();
//    _subscription.cancel();
    _controller.dispose();
  }

//  void _onStateChanged(AdLoadState state) {
//    switch (state) {
//      case AdLoadState.loading:
//        setState(() {
//          _height = 0;
//        });
//        break;
//
//      case AdLoadState.loadCompleted:
//        setState(() {
//          _height = 250;
//        });
//        break;
//
//      default:
//        break;
//    }
//  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: widget.placeType == PlaceType.General
            ? Text('Nearby Places')
            : widget.placeType == PlaceType.Food
                ? Text('Nearby Foods')
                : Text('Nearby Hotels'),
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                if (widget.placeType != PlaceType.Hotel)
                  Container(
                    height: 40.0,
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    width: double.infinity,
                    child: searchTypeOptions(),
                  ),
                FutureBuilder(
                  future: getNearbyPlaces,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<GoogleNearByPlace>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                        child: SpinKitWave(
                          color: Colors.white,
                          size: 50.0,
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final place = snapshot.data[index];

                              if (index > 0 && index % 7 == 0) {
                                return Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: EdgeInsets.all(16.0),
                                  child: NativeAdmob(
                                    adUnitID: kTestAdUnit,
                                    // TODO: use below in production
//                                    adUnitID:
//                                        isIos ? _iOSAdUnitID : _androidAdUnitId,
                                    controller: _controller,
                                  ),
                                );
                              }

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
                                        placeRatingTotals: place.ratingTotals,
                                        placeOpenNow: place.openNow,
                                        placeType:
                                            place.types[0].split('_').join(' '),
                                        placeAddress: place.address,
                                      ),
                                    ),
                                  );
                                },
                                child: place.openNow != null
                                    ? PlaceCard(
                                        placeCategory: place.types[0],
                                        placeName: place.name,
                                        placeImgPath: place.photos.length > 0
                                            ? buildPhotoURL(place.photos[0])
                                            : 'assets/images/no_image_found.jpg',
                                        placeRating: place.rating,
                                        placeReview: place.ratingTotals != null
                                            ? '(${place.ratingTotals})'
                                            : '(0)',
                                        openNow: place.openNow,
                                        isExplore: true,
                                        placeId: place.placeId,
                                      )
                                    : PlaceCard(
                                        placeCategory: place.types[0],
                                        placeName: place.name,
                                        placeImgPath: place.photos.length > 0
                                            ? buildPhotoURL(place.photos[0])
                                            : 'assets/images/no_image_found.jpg',
                                        placeRating: place.rating,
                                        placeReview: place.ratingTotals != null
                                            ? '(${place.ratingTotals})'
                                            : '(0)',
                                        isExplore: true,
                                        placeId: place.placeId,
                                      ),
                              );
                            }),
                      );
                    }

                    if (snapshot.hasError)
                      return Text(
                        snapshot.error.toString(),
                        style: TextStyle(color: Colors.white),
                      );
                    return Container();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlaceSearchTypeOption extends StatelessWidget {
  final NearbySearchType searchType;
  final Color displayColor;
  final Function onPress;

  _PlaceSearchTypeOption(
      {@required this.onPress,
      @required this.searchType,
      @required this.displayColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5.0,
      ),
      child: FlatButton(
        color: displayColor,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(
            color: Color(0XFF69A4FF),
          ),
        ),
        child: Text(
          getSearchTypeString(searchType).split('_').join(' '),
          style: TextStyle(
            color: Color(0XFF69A4FF),
          ),
        ),
        onPressed: onPress,
      ),
    );
  }
}
