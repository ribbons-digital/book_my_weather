import 'dart:math' as math;

import 'package:book_my_weather/models/google_place_detail.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/trip_visiting.dart';
import 'package:book_my_weather/pages/image_full_screen.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/services/google_places.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:book_my_weather/widgets/place_detail_widget.dart';
import 'package:book_my_weather/widgets/place_weather_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetail extends StatefulWidget {
  static const String id = 'placeDetail';

  final String placeId;
  final String placeName;
  final String placeType;
  final double placeRating;
  final int placeRatingTotals;
  final bool placeOpenNow;
  final String placeAddress;

  PlaceDetail({
    @required this.placeId,
    @required this.placeName,
    @required this.placeType,
    @required this.placeRating,
    @required this.placeOpenNow,
    @required this.placeRatingTotals,
    @required this.placeAddress,
  });

  @override
  _PlaceDetailState createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Future<GooglePlaceDetail> placeDetails;
  TextEditingController _dateEditingController;
  TextEditingController _timeEditingController;
  DateTime visitingDate;
  TimeOfDay visitingTime;
  double tabViewHeight = 1000.0;

  SliverPersistentHeader makeHeader(Widget child) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 60.0,
        child: child,
      ),
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _dateEditingController = TextEditingController();
    _timeEditingController = TextEditingController();
    placeDetails = getPlaceDetail(widget.placeId);
    super.initState();
  }

  Future<GooglePlaceDetail> getPlaceDetail(String placeId) async {
    GooglePlaces place = GooglePlaces();
    return await place.getPlaceDetail(placeId: placeId);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void goToWeatherTab() {
    setState(() {
      _tabController.index = 1;
    });
  }

  List<Widget> heroImages(BuildContext context, List<String> photoReferences) {
    return photoReferences.map((reference) {
      final url = buildPhotoURL(reference);

      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ImageFullScreen(
              tag: DateTime.now().toIso8601String(),
              url: url,
            );
          }));
        },
        child: Hero(
          tag: DateTime.now().toIso8601String(),
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _dateEditingController.dispose();
    _timeEditingController.dispose();
  }

  bool checkIsPlaceSaved(List<TripVisiting> tripVisitings, String placeId) {
    if (tripVisitings != null && tripVisitings.length > 0) {
      final placeIds = tripVisitings.map((visiting) {
        return visiting.placeId;
      }).toList();
      return placeIds.contains(placeId);
    }
    return false;
  }

  void pickDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));

    if (pickedDate != null && pickedDate != DateTime.now()) {
      _dateEditingController.text = DateFormat('yMMMMd').format(pickedDate);
      setState(() {
        visitingDate = pickedDate;
      });
    }
  }

  void pickTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final time = '${pickedTime.hour} : ${pickedTime.minute}';
      _timeEditingController.text = time;
      setState(() {
        visitingTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final db = DatabaseService();
    final tripId = Provider.of<TripState>(context).tripId;

    return FutureBuilder(
      future: placeDetails,
      builder:
          (BuildContext context, AsyncSnapshot<GooglePlaceDetail> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitWave(
            color: Colors.white,
            size: 50.0,
          );
        }

        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          final placeDetail = snapshot.data;

          return Scaffold(
            backgroundColor: Colors.white,
            body: StreamProvider<List<TripVisiting>>.value(
              value: db.streamTripVisitings(tripId),
              child: Consumer<List<TripVisiting>>(
                builder: (_, tripVisitings, __) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        expandedHeight: height / 4,
                        pinned: true,
                        leading: IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            size: 35.0,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 35.0,
                            ),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: PageView(
                            scrollDirection: Axis.horizontal,
                            children: heroImages(context, placeDetail.photos),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: Text(widget.placeName),
                              subtitle: Text(widget.placeType),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '${widget.placeRating}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SmoothStarRating(
                                    allowHalfRating: true,
                                    onRatingChanged: (v) {
//                              rating = v;
//                              setState(() {});
                                    },
                                    starCount: 5,
                                    rating: widget.placeRating,
                                    size: 18.0,
                                    filledIconData: Icons.star,
                                    halfFilledIconData: Icons.star_half,
                                    color: Color(0XFF69A4FF),
                                    borderColor: Color(0XFF69A4FF),
                                    spacing: 0.0,
                                  ),
                                  Text(
                                    '(${widget.placeRatingTotals})',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.placeOpenNow != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  bottom: 8.0,
                                  top: 8.0,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: widget.placeOpenNow
                                            ? 'Open now'
                                            : 'Closed - ',
                                        style: TextStyle(
                                          color: widget.placeOpenNow
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 15,
                                        ),
                                      ),
                                      if (!widget.placeOpenNow ||
                                          placeDetail.todayOpeningHour.length >
                                              0)
                                        TextSpan(
                                          text: placeDetail.todayOpeningHour ==
                                                  '24 Hours'
                                              ? ' Opens ${placeDetail.todayOpeningHour}'
                                              : ' Opens at ${placeDetail.todayOpeningHour}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            if (widget.placeOpenNow == null)
                              SizedBox(
                                height: 10.0,
                              ),
                            Container(
                              width: double.infinity,
                              height: 40.0,
                              padding: EdgeInsets.only(left: 15.0),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Color(0XFF69A4FF),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.phone,
                                          color: Color(0XFF69A4FF),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          'Call',
                                          style: TextStyle(
                                            color: Color(0XFF69A4FF),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      final url =
                                          'tel:${placeDetail.phoneNumber}';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Something is wrong';
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.share,
                                          color: Color(0XFF69A4FF),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                            color: Color(0XFF69A4FF),
                                          ),
                                        ),
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Color(0XFF69A4FF),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final url =
                                          'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=url&place_id=${widget.placeId}';
                                      NetworkHelper networkHelper =
                                          NetworkHelper(url);

                                      try {
                                        Map<String, dynamic> result =
                                            await networkHelper.getData();
                                        Share.share(result['result']['url']);
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          checkIsPlaceSaved(
                                                  tripVisitings, widget.placeId)
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: Color(0XFF69A4FF),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Color(0XFF69A4FF),
                                          ),
                                        ),
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Color(0XFF69A4FF),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (!checkIsPlaceSaved(
                                          tripVisitings, widget.placeId)) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'When are you visiting?'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    TextField(
                                                      style: TextStyle(
                                                          color: Color(
                                                              0XFF436DA6)),
                                                      controller:
                                                          _dateEditingController,
                                                      onTap: () async {
                                                        pickDate(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Select Date',
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Color(0XFF436DA6),
                                                          fontSize: 24.0,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                        ),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0XFF69A4FF),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    TextField(
                                                      style: TextStyle(
                                                          color: Color(
                                                              0XFF436DA6)),
                                                      controller:
                                                          _timeEditingController,
                                                      onTap: () async {
                                                        pickTime(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Select Time',
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Color(0XFF436DA6),
                                                          fontSize: 24.0,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                        ),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0XFF69A4FF),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text('Save'),
                                                    onPressed: () async {
                                                      if (visitingDate ==
                                                              null ||
                                                          visitingTime == null)
                                                        return;
                                                      final visitingDateTime =
                                                          DateTime(
                                                              visitingDate.year,
                                                              visitingDate
                                                                  .month,
                                                              visitingDate.day,
                                                              visitingTime.hour,
                                                              visitingTime
                                                                  .minute);
                                                      TripVisiting
                                                          newTripVisiting =
                                                          TripVisiting(
                                                        photo: placeDetail
                                                                    .photos
                                                                    .length >
                                                                0
                                                            ? placeDetail
                                                                .photos[0]
                                                            : '',
                                                        placeId: widget.placeId,
                                                        placeName:
                                                            widget.placeName,
                                                        placeType:
                                                            widget.placeType,
                                                        visitingDate: Timestamp
                                                            .fromMicrosecondsSinceEpoch(
                                                                visitingDateTime
                                                                        .millisecondsSinceEpoch *
                                                                    1000),
                                                      );

                                                      await db.addTripVisiting(
                                                          tripId,
                                                          newTripVisiting);
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      } else {
                                        final tripVisitingId = tripVisitings
                                            .where((visiting) =>
                                                visiting.placeId ==
                                                widget.placeId)
                                            .toList()[0]
                                            .id;
                                        await db.deleteTripVisiting(
                                            tripId, tripVisitingId);
                                      }
                                    },
                                  ),
                                ],
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
                          ],
                        ),
                      ),
                      makeHeader(
                        Container(
                          color: Colors.white,
                          child: Center(
                            child: TabBar(
                              isScrollable: true,
                              labelColor: Color(0XFF69A4FF),
                              unselectedLabelColor: Colors.black26,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorWeight: 10.0,
                              indicatorColor: Color(0XFF69A4FF),
                              indicatorPadding:
                                  EdgeInsets.symmetric(horizontal: 8.0),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                              controller: _tabController,
                              tabs: <Widget>[
                                Tab(
                                  child: Text('Overview'),
                                ),
                                Tab(
                                  child: Text('Weather'),
                                ),
                                Tab(
                                  child: Text('Photos'),
                                ),
                              ].toList(),
                            ),
                          ),
                        ),
                      ),
                      <Widget>[
                        SliverToBoxAdapter(
                          child: PlaceOverview(
                            height: height,
                            width: width,
                            goToWeatherTab: goToWeatherTab,
                            address: placeDetail.address,
                            phoneNumber: placeDetail.phoneNumber,
                            website: placeDetail.website,
                            openingHours: placeDetail.openingHours,
                            googleUrl: placeDetail.googleUrl,
                          ),
                        ),
                        PlaceWeather(
                          address: placeDetail.address,
                        ),
                        SliverGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          children: heroImages(context, placeDetail.photos),
                        ),
                      ][_tabController.index]
                    ],
                  );
                },
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text(
            snapshot.error.toString(),
            style: TextStyle(
              color: Colors.white,
            ),
          );
        }

        return Container();
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
