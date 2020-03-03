import 'package:book_my_weather/models/currentlyWeather.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/pages/new_trip_screen.dart';
import 'package:book_my_weather/pages/signin_register_screen.dart';
import 'package:book_my_weather/pages/trip_detail_screen.dart';
import 'package:book_my_weather/widgets/trip_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripsScreen extends StatefulWidget {
  static const String id = 'trips';
  final Function setFilterString;
  final int selectedScreenIndex;

  TripsScreen(
      {@required this.setFilterString, @required this.selectedScreenIndex});

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  TextEditingController _textEditingController;
  List<CurrentlyWeather> _temperatureList = [];

  String dropdownValue = 'Upcoming';
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.width < 600 ? 20.0 : 50.0;
    final User user = Provider.of<User>(context);
    final trips = Provider.of<List<Trip>>(context);
    final bool shouldUpdateWeather =
        _temperatureList.length > 0 && _temperatureList.length == trips.length;

    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.arrow_back_ios),
        actions: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    items: <String>['Upcoming', 'Past']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (user != null) {
                        Navigator.pushNamed(context, NewTrip.id);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignInRegisterScreen();
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: h,
              top: 20.0,
              right: h,
              bottom: 20.0,
            ),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                hintText: 'Search',
                hintStyle: TextStyle(color: Color(0XFF8D9093)),
                filled: true,
                fillColor: Color(0XFFE5E7EA),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Color(0XFFE5E7EA),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Text(
                'Trips',
                style: TextStyle(
                  color: Color(
                    0XFF69A4FF,
                  ),
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          isEmpty
              ? Align(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'No Upcoming Trips',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          isEmpty
              ? Align(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Tap the "+" button to add your first trip',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          if (trips != null && trips.length > 0)
            Expanded(
              child: ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
//                    Navigator.pushNamed(context, TripDetail.id);
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 550),
                            pageBuilder: (context, _, __) => TripDetail(
                              index: index,
//                              currentTemp: shouldUpdateWeather
//                                  ? '${_temperatureList[index].temperature.toStringAsFixed(0)}'
//                                  : '--',
//                              precipitation: shouldUpdateWeather
//                                  ? _temperatureList[index]
//                                      .precipProbability
//                                      .toStringAsFixed(0)
//                                  : '0',
                            ),
                          ),
                        );
                      },
                      child: TripWidget(
                        index: index,
                      ),
                    );
                  }),
            ),
        ],
      ),
    );
  }
}
