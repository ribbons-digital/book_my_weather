import 'package:book_my_weather/models/character.dart';
import 'package:book_my_weather/styleguide.dart';
import 'package:book_my_weather/widgets/daily_weather_detail_widget.dart';
import 'package:book_my_weather/widgets/daily_weather_heading.dart';
import 'package:book_my_weather/widgets/daily_weather_widget.dart';
import 'package:book_my_weather/widgets/hourly_weather_widget.dart';
import 'package:flutter/material.dart';

import '../styleguide.dart';

class WeatherDetailScreen extends StatefulWidget {
  final Character character;

  const WeatherDetailScreen({Key key, this.character}) : super(key: key);

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

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: "background-${widget.character.name}",
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
                  'Waverton',
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
                      ListView(
                        padding: EdgeInsets.all(10.0),
                        children: <Widget>[
                          GestureDetector(
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
                                    heightFactor: 0.66,
                                    child: DailyWeatherDetail(),
                                  );
                                },
                              );
                            },
                            child: HourlyWeatherWidget(
                              hour: ' 8AM',
                              temperature: '26º',
                              weatherIconPath: 'assets/images/sunny.png',
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          HourlyWeatherWidget(
                            hour: ' 9AM',
                            temperature: '26º',
                            weatherIconPath: 'assets/images/sunny.png',
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          HourlyWeatherWidget(
                            hour: '10AM',
                            temperature: '26º',
                            weatherIconPath: 'assets/images/sunny.png',
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          HourlyWeatherWidget(
                            hour: '11AM',
                            temperature: '26º',
                            weatherIconPath: 'assets/images/sunny.png',
                          ),
                        ],
                      ),
                      ListView(
                        padding: EdgeInsets.all(10.0),
                        children: <Widget>[
                          GestureDetector(
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
                                    heightFactor: 0.66,
                                    child: DailyWeatherDetail(),
                                  );
                                },
                              );
                            },
                            child: DailyWeather(
                              date: 'Sat. 25, Jan.',
                              weatherConditionImgPath:
                                  'assets/images/sunny.png',
                              tempRange: '32º / 22º',
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.65,
                                    child: DailyWeatherDetail(),
                                  );
                                },
                              );
                            },
                            child: DailyWeather(
                              date: 'Sat. 25, Jan.',
                              weatherConditionImgPath:
                                  'assets/images/sunny.png',
                              tempRange: '32º / 22º',
                            ),
                          ),
                        ],
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
