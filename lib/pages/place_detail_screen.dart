import 'dart:math' as math;

import 'package:despicables_me_app/widgets/hourly_weather_widget.dart';
import 'package:despicables_me_app/widgets/place_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PlaceDetail extends StatefulWidget {
  static const String id = 'placeDetail';

  @override
  _PlaceDetailState createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

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
    super.initState();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
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
              children: <Widget>[
                Image.asset(
                  'assets/images/taipei_101.jpg',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/images/shanghai.jpg',
                  fit: BoxFit.cover,
                ),
              ],
            )),
          ),
//          SliverToBoxAdapter(
//            child: PlaceDetailWidget(
//              tabController: _tabController,
//            ),
//          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text('Taipei 101'),
                  subtitle: Text('Shopping'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '4.5',
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
                        rating: 4.3,
                        size: 18.0,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        color: Color(0XFF69A4FF),
                        borderColor: Color(0XFF69A4FF),
                        spacing: 0.0,
                      ),
                      Text(
                        '(45,867)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 8.0),
                  child: Text(
                    'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Closed - ',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: 'Opens 11am',
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
//                      SvgPicture.asset(
//                        'assets/images/note_solid.svg',
//                        width: 14.0,
//                        height: 16.0,
//                        color: Color(0XFF69A4FF),
//                      ),
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
                        onPressed: () {},
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
                        onPressed: () {},
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
//          SliverToBoxAdapter(
//            child: ConstrainedBox(
//              constraints: BoxConstraints(
//                minHeight: 300.0,
//                maxHeight: 1000.0,
//              ),
//              child: TabBarView(
//                controller: _tabController,
//                children: <Widget>[
//                  PlaceOverview(height: height, width: width),
//                  PlaceWeather(),
//                  Text('3'),
//                  Text('4'),
//                ],
//              ),
//            ),
//          )
          <Widget>[
            SliverToBoxAdapter(
              child: PlaceOverview(height: height, width: width),
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
}

class PlaceWeather extends StatelessWidget {
  const PlaceWeather({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(List.generate(24, (i) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            bottom: 16.0,
          ),
          child: HourlyWeatherWidget(
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
