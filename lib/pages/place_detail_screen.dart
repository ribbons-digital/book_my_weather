import 'dart:math' as math;

import 'package:book_my_weather/models/google_place_detail.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/google_places.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:book_my_weather/widgets/daily_weather_widget.dart';
import 'package:book_my_weather/widgets/hourly_weather_widget.dart';
import 'package:book_my_weather/widgets/place_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
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
  Future<GooglePlaceDetail> placeDetail;

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
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    placeDetail = getPlaceDetail(widget.placeId);
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

  List<Widget> heroImages(List<String> photoReferences) {
    List<String> photoUrls = photoReferences.map((photoReference) {
      return buildPhotoURL(photoReference);
    }).toList();
    return photoUrls.map((url) {
      return Image.network(
        url,
        fit: BoxFit.cover,
      );
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: placeDetail,
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
          final day = DateFormat('E').format(DateTime.now());

          final todayOpenHour = placeDetail.openingHours
                  .where((hour) => hour.contains(day))
                  .toList()[0]
                  .split(':')[1] +
              ':' +
              placeDetail.openingHours
                  .where((hour) => hour.contains(day))
                  .toList()[0]
                  .split(':')[2]
                  .split(' ')[0] +
              placeDetail.openingHours
                  .where((hour) => hour.contains(day))
                  .toList()[0]
                  .split(':')[2]
                  .split(' ')[1];

          return Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
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
//                title: Text(
//                  'Taipei 101',
//                  style: TextStyle(
//                    color: Colors.white,
//                  ),
//                ),
                      background: PageView(
                    scrollDirection: Axis.horizontal,
                    children: heroImages(placeDetail.photos),
//                    children: <Widget>[
//                      Image.asset(
//                        'assets/images/taipei_101.jpg',
//                        fit: BoxFit.cover,
//                      ),
//                      Image.asset(
//                        'assets/images/shanghai.jpg',
//                        fit: BoxFit.cover,
//                      ),
//                    ],
                  )),
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
//                      Padding(
//                        padding: const EdgeInsets.only(
//                            left: 15.0, top: 10.0, bottom: 8.0),
//                        child: Text(
//                          'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
//                          style: TextStyle(
//                            fontSize: 16.0,
//                          ),
//                          maxLines: 3,
//                          overflow: TextOverflow.ellipsis,
//                        ),
//                      ),
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
                              if (!widget.placeOpenNow)
                                TextSpan(
                                  text: 'Opens$todayOpenHour',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                            ],
                          ),
                        ),
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
                                borderRadius: new BorderRadius.circular(18.0),
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
                                final url = 'tel:${placeDetail.phoneNumber}';
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
                                borderRadius: new BorderRadius.circular(18.0),
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
                                    Icons.bookmark,
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
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color(0XFF69A4FF),
                                ),
                              ),
                              onPressed: () {},
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
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 8.0),
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
                          Tab(
                            child: Text('Notes'),
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
                  PlaceWeather(),
                  SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    children: List.generate(20, (i) {
                      return Container(
                        color: Colors.teal[100 * (i % 9)],
                        child: Image.network(
                          'https://communication-skills.info/wp-content/uploads/European-common-cat.jpg',
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                  ),
                  SliverToBoxAdapter(
                    child: Text('4'),
                  ),
                ][_tabController.index]
              ],
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

class PlaceWeather extends StatefulWidget {
  const PlaceWeather({
    Key key,
  }) : super(key: key);

  @override
  _PlaceWeatherState createState() => _PlaceWeatherState();
}

class _PlaceWeatherState extends State<PlaceWeather> {
  bool isHourly = true;

  void switchWeatherView() {
    setState(() {
      isHourly = !isHourly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(List.generate(isHourly ? 24 : 7, (i) {
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
                value: isHourly ? 'Hourly' : 'Daily',
                elevation: 16,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w200,
                  fontSize: 20.0,
                ),
                items: <String>['Hourly', 'Daily']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    newValue == 'Hourly' ? isHourly = true : isHourly = false;
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
                  hourIndex: 0,
                  hour: '$i:00',
                  temperature: '31º',
                  weatherIconPath: 'assets/images/sunny.png',
                  hourTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w100,
                    fontSize: 28.0,
                  ),
                  weatherBoxBackgroundColor: Colors.white,
                  tempTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w100,
                    fontSize: 28.0,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: DailyWeather(
                  date: 'Sat. 25, Jan.',
                  weatherConditionImgPath: 'assets/images/sunny.png',
                  tempRange: '32º / 22º',
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
      })),
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
