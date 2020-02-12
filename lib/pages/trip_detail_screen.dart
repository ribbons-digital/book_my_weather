import 'package:despicables_me_app/pages/places_screen.dart';
import 'package:despicables_me_app/widgets/trip_detail_grid_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TripDetail extends StatelessWidget {
  static const String id = 'tripDetail';

  final String imgPath;
  final String currentTemp;
  final String precipitation;
  final String tripName;
  final String city;
  final String startDate;
  final int index;

  TripDetail({
    @required this.imgPath,
    @required this.currentTemp,
    @required this.precipitation,
    @required this.tripName,
    @required this.city,
    @required this.startDate,
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: Image.asset(
                    imgPath,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 30.0,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 9.0),
                        child: Icon(
                          Icons.edit,
                          size: 30.0,
                          color: Colors.white,
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
                        city,
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
                        tripName,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Hero(
                              tag: 'tempIcon-$index',
                              child: SvgPicture.asset('assets/images/sunny.svg',
                                  color: Colors.white,
                                  semanticsLabel: 'sunny-line'),
                            ),
                            Hero(
                              tag: 'temp-$index',
                              child: Material(
                                color: Color(0X00FFFFFF),
                                child: Text(
                                  currentTemp + 'º currently',
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
                          tag: 'precipitation-1',
                          child: Material(
                            color: Color(0X00FFFFFF),
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Image.asset('assets/images/rain-solid.png'),
                                Text(
                                  precipitation + '%',
                                )
                              ],
                            ),
                          ),
                        )
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
                                  '13 days, from today',
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
                              DateFormat.yMd('en_US').format(
                                DateTime.parse(startDate),
                              ),
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
                    Navigator.pushNamed(context, PlacesScreen.id);
                  },
                  child: TripDetailGridItem(
                    tag: 'places',
                    gridImgPath: 'assets/images/places.jpg',
                    gridItemText: 'Places',
                  ),
                ),
                TripDetailGridItem(
                  tag: 'foods',
                  gridImgPath: 'assets/images/food.jpg',
                  gridItemText: 'Foods',
                ),
                TripDetailGridItem(
                  tag: 'hotels',
                  gridImgPath: 'assets/images/hotels.jpg',
                  gridItemText: 'Hotels',
                ),
                TripDetailGridItem(
                  tag: 'flights',
                  gridImgPath: 'assets/images/flights.jpg',
                  gridItemText: 'Flights',
                ),
                TripDetailGridItem(
                  tag: 'weather',
                  gridImgPath: 'assets/images/weather-2.jpg',
                  gridItemText: 'Weather',
                ),
                TripDetailGridItem(
                  tag: 'saved-places',
                  gridImgPath: 'assets/images/saved_places.jpg',
                  gridItemText: 'Saved Places',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
