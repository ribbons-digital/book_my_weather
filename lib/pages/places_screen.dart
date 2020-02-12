import 'package:despicables_me_app/pages/place_detail_screen.dart';
import 'package:despicables_me_app/widgets/explore_place_card_widget.dart';
import 'package:despicables_me_app/widgets/place_card_widget.dart';
import 'package:flutter/material.dart';

class PlacesScreen extends StatefulWidget {
  static const String id = 'placesScreen';

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    print(width / height);

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
                            placeDesc:
                                'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
                            placeImgPath: 'assets/images/taipei_101.jpg',
                            placeOpenHour: '11:00am',
                            placeRating: '4.3',
                            placeReview: '(45,867)',
                            currentTemp: '31',
                            currentWeatherIconPath: 'assets/images/sunny.svg',
                          ),
                        ),
                        PlaceCard(
                          placeCategory: 'Shopping',
                          placeName: 'Taipei 101',
                          placeDesc:
                              'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
                          placeImgPath: 'assets/images/taipei_101.jpg',
                          placeOpenHour: '11:00am',
                          placeRating: '4.3',
                          placeReview: '(45,867)',
                          currentTemp: '31',
                          currentWeatherIconPath: 'assets/images/sunny.svg',
                        ),
                      ],
                    ),
                    GridView.count(
                      primary: false,
//                      childAspectRatio: width / height < 0.5
//                          ? (width / 1.8) / (height / 2.6)
//                          : width / height > 0.5 && width / height < 0.6
//                          ? width / height
//                          : width / height > 0.6
//                          ? (width / 1.8) / (height / 2.2)
//                          : width / height,
                      childAspectRatio: width / height < 0.5
                          ? (width / 1.8) / (height / 2.6)
                          : width / height,
                      crossAxisCount: 2,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PlaceDetail.id);
                          },
                          child: ExplorePlaceCardWidget(),
                        ),
                        ExplorePlaceCardWidget(),
                        ExplorePlaceCardWidget(),
                        ExplorePlaceCardWidget(),
                        ExplorePlaceCardWidget(),
                        ExplorePlaceCardWidget(),
                        ExplorePlaceCardWidget(),
                        ExplorePlaceCardWidget(),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
