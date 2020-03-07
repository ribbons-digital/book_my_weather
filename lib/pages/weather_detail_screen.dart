import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/styleguide.dart';
import 'package:book_my_weather/widgets/daily_weather_heading.dart';
import 'package:book_my_weather/widgets/daily_weather_widget.dart';
import 'package:book_my_weather/widgets/hourly_weather_widget.dart';
import 'package:book_my_weather/widgets/weather_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styleguide.dart';

class WeatherDetailScreen extends StatefulWidget {
  final Place place;

  const WeatherDetailScreen({Key key, this.place}) : super(key: key);

  @override
  _WeatherDetailScreenState createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
//    final screenWidth = MediaQuery.of(context).size.width;

    final placeData = Provider.of<PlaceData>(context);
    final hourlyWeatherList =
        placeData.places[placeData.currentPlaceIndex].weather.hourly.data;
    final dailyWeatherList =
        placeData.places[placeData.currentPlaceIndex].weather.daily.data;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: "background-${widget.place.name}",
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
//                gradient: LinearGradient(
//                  colors: widget.character.colors,
//                  begin: Alignment.topRight,
//                  end: Alignment.bottomLeft,
//                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 22),
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.close),
                color: Colors.white.withOpacity(0.9),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.place.address,
                  style: AppTheme.display1,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DailyWeatherHeading(screenHeight: screenHeight),
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
                      child: Text('Today'),
                    ),
                    Tab(
                      child: Text('Forecast'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemCount: hourlyWeatherList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final placeData = Provider.of<PlaceData>(context);
                          final place =
                              placeData.places[placeData.currentPlaceIndex];
                          final hourlyWeatherData = place.weather.hourly.data;

                          if (index > 11) return null;

                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.6,
                                    child: WeatherDetail(
                                      rowIndex: index,
                                    ),
                                  );
                                },
                              );
                            },
                            child: HourlyWeatherWidget(
                              hourIndex: index,
                              weatherIconPath: 'assets/images/sunny.png',
                              hourlyWeatherData: hourlyWeatherData,
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemCount: dailyWeatherList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final placeData = Provider.of<PlaceData>(context);
                          final place =
                              placeData.places[placeData.currentPlaceIndex];
                          final dailyWeatherData = place.weather.daily.data;

                          if (index > 6) return null;
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                backgroundColor: Colors.white,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.6,
                                    child: WeatherDetail(
                                      rowIndex: index,
                                      isHourly: false,
                                    ),
                                  );
                                },
                              );
                            },
                            child: DailyWeather(
                              dayIndex: index,
                              dailyWeatherData: dailyWeatherData,
                              weatherConditionImgPath:
                                  'assets/images/sunny.png',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
