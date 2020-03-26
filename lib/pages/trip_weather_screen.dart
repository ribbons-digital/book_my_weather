import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/setting.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/styleguide.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:book_my_weather/widgets/daily_weather_heading.dart';
import 'package:book_my_weather/widgets/daily_weather_widget.dart';
import 'package:book_my_weather/widgets/hourly_weather_widget.dart';
import 'package:book_my_weather/widgets/weather_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../styleguide.dart';

class TripWeatherScreen extends StatefulWidget {
  final Trip trip;
  static const String id = 'tripWeatherScreen';

  const TripWeatherScreen({Key key, this.trip}) : super(key: key);

  @override
  _TripWeatherScreenState createState() => _TripWeatherScreenState();
}

class _TripWeatherScreenState extends State<TripWeatherScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Future<Weather> getWeather;

  Future<Weather> getWeatherForecast() async {
    WeatherModel weather = WeatherModel();

    SettingModel settingModel = SettingModel();
    final currentSetting = settingModel.getCurrentSetting();
    Location location = Location();
    final lat = widget.trip.location.latitude;
    final lng = widget.trip.location.longitude;
    await location.getPlaceMarkFromCoordinates(
      lat: lat,
      lng: lng,
    );

    Weather weatherForecast = await weather.getLocationWeather(
      type: RequestedWeatherType.All,
      useCelsius: currentSetting.useCelsius,
      latitude: location.latitude,
      longitude: location.longitude,
    );

    return weatherForecast;
  }

  @override
  void initState() {
    getWeather = getWeatherForecast();

    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final startDateISOString = timeStampToISOString(widget.trip.startDate);
    int daysLeft =
        DateTime.parse(startDateISOString).difference(DateTime.now()).inDays;

    final today = DateFormat('EEE, MMM d').format(DateTime.now()).toString();

    return Scaffold(
        body: FutureBuilder(
      future: getWeather,
      builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data.hourly.data.length > 0 &&
            snapshot.data.daily.data.length > 0) {
          final hourlyWeatherList = snapshot.data.hourly.data;
          final dailyWeatherList = snapshot.data.daily.data;
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          widget.trip.destination,
                          style: AppTheme.display1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DailyWeatherHeading(
                    screenHeight: screenHeight,
                    dailyWeather: dailyWeatherList[0],
                    hourlyWeather: hourlyWeatherList[0],
                    today: today,
                  ),
                  SizedBox(height: 22),
                  if (daysLeft <= 7)
                    Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.blueGrey,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 10.0,
                        indicatorPadding:
                            EdgeInsets.symmetric(horizontal: 10.0),
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
                  if (daysLeft <= 7)
                    Expanded(
                      child: Container(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            ListView.builder(
                              padding: EdgeInsets.all(10.0),
                              itemCount: hourlyWeatherList.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index > 11) return null;

                                return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                    hourlyWeatherData: hourlyWeatherList,
                                  ),
                                );
                              },
                            ),
                            ListView.builder(
                              padding: EdgeInsets.all(10.0),
                              itemCount: dailyWeatherList.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index > 6) return null;
                                return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                    dailyWeatherData: dailyWeatherList,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (daysLeft > 7)
                    Text(
                      '📅 Weather forecast will be available within 7 days before your trip starts. Please check back later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w200,
                      ),
                    )
                ],
              ),
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitWave(
            size: 50.0,
            color: Colors.white,
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
    ));
  }
}
