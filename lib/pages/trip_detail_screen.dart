import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/pages/places_screen.dart';
import 'package:book_my_weather/pages/trip_screen.dart';
import 'package:book_my_weather/pages/trip_todos_screen.dart';
import 'package:book_my_weather/pages/trip_visiting_screen.dart';
import 'package:book_my_weather/pages/trip_weather_screen.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:book_my_weather/widgets/trip_detail_grid_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripDetail extends StatelessWidget {
  static const String id = 'tripDetail';

  @override
  Widget build(BuildContext context) {
    final index = Provider.of<TripState>(context).selectedIndex;
    final trip = Provider.of<List<Trip>>(context)[index];

    final startDateISOString = timeStampToISOString(trip.startDate);
    final startDateToDateString = timeStampToDateString(trip.startDate);
    String daysLeft = DateTime.parse(startDateISOString)
        .difference(DateTime.now())
        .inDays
        .toString();
    WeatherModel weatherModel = WeatherModel();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Hero(
                  tag: 'city-img-$index',
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.network(
                      trip.heroImages[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(
                          left: 8.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color(0x42FFFFFF),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(
                          right: 8.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color(0x42FFFFFF),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, _, __) => TripScreen(
                                  existingTrip: trip,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.2),
                  child: Hero(
                    tag: 'city-$index',
                    child: Material(
                      color: Color(0X00FFFFFF),
                      child: Text(
                        trip.destination,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.1),
                  child: Hero(
                    tag: 'tripName-$index',
                    child: Material(
                      color: Color(0X00FFFFFF),
                      child: Text(
                        trip.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.6),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 6.0,
                      right: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Hero(
                              tag: 'tempIcon-$index',
                              child: weatherModel.getWeatherIcon(
                                condition: trip.weatherIcon,
                                iconColor: Color(0xFFFFA500),
                                width: 30.0,
                                height: 30.0,
                              ),
                            ),
                            Hero(
                              tag: 'temp-$index',
                              child: Material(
                                color: Color(0X00FFFFFF),
                                child: Text(
                                  '${trip.temperature}º currently',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.9),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 9.0,
                      right: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Hero(
                              tag: 'timer-icon-$index',
                              child: Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                            ),
                            Hero(
                              tag: 'daysLeft-1',
                              child: Material(
                                color: Color(0X00FFFFFF),
                                child: Text(
                                  '$daysLeft days, from today',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Hero(
                          tag: 'startDate-1',
                          child: Material(
                            color: Color(0X00FFFFFF),
                            child: Text(
                              startDateToDateString,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 550),
                        pageBuilder: (context, _, __) => PlacesScreen(
                          trip: trip,
                          placeType: PlaceType.General,
                        ),
                      ),
                    );
                  },
                  child: TripDetailGridItem(
                    tag: 'places',
                    gridImgPath: 'assets/images/places.jpg',
                    gridItemText: 'Places',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 550),
                        pageBuilder: (context, _, __) => PlacesScreen(
                          trip: trip,
                          placeType: PlaceType.Food,
                        ),
                      ),
                    );
                  },
                  child: TripDetailGridItem(
                    tag: 'foods',
                    gridImgPath: 'assets/images/food.jpg',
                    gridItemText: 'Foods',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 550),
                        pageBuilder: (context, _, __) => PlacesScreen(
                          trip: trip,
                          placeType: PlaceType.Hotel,
                        ),
                      ),
                    );
                  },
                  child: TripDetailGridItem(
                    tag: 'hotels',
                    gridImgPath: 'assets/images/hotels.jpg',
                    gridItemText: 'Hotels',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 550),
                        pageBuilder: (context, _, __) => TripWeatherScreen(
                          trip: trip,
                        ),
                      ),
                    );
                  },
                  child: TripDetailGridItem(
                    tag: 'weather',
                    gridImgPath: 'assets/images/weather-2.jpg',
                    gridItemText: 'Weather',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, TripTodosScreen.id);
                  },
                  child: TripDetailGridItem(
                    tag: 'todos',
                    gridImgPath: 'assets/images/todo.jpg',
                    gridItemText: 'To Dos',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, TripVisitingScreen.id);
                  },
                  child: TripDetailGridItem(
                    tag: 'visiting',
                    gridImgPath: 'assets/images/saved_places.jpg',
                    gridItemText: 'Visiting',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
