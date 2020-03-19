import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripWidget extends StatefulWidget {
  final int index;

  TripWidget({
    @required this.index,
  });

  @override
  _TripWidgetState createState() => _TripWidgetState();
}

class _TripWidgetState extends State<TripWidget> {
  @override
  Widget build(BuildContext context) {
    final trips = Provider.of<List<Trip>>(context);
    final startDateToDateString =
        timeStampToDateString(trips[widget.index].startDate);

    WeatherModel weatherModel = WeatherModel();

    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width - 40
            : MediaQuery.of(context).size.width - 100,
        height: 161,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: 'card-background-${widget.index}',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.black,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Hero(
                tag: 'city-img-${widget.index}',
                child: Opacity(
                  opacity: 0.6,
                  child: Image.network(
                    trips[widget.index].heroImages[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: 'tempIcon-${widget.index}',
                            child: weatherModel.getWeatherIcon(
                              condition: trips[widget.index].weatherIcon,
                              iconColor: Color(0xFFFFA500),
                              width: 30.0,
                              height: 30.0,
                            ),
                          ),
                          Hero(
                            tag: 'temp-${widget.index}',
                            child: Material(
                              color: Color(0X00FFFFFF),
                              child: Text(
                                '${trips[widget.index].temperature}º currently',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () async {
                          final db = DatabaseService();
                          WeatherModel weather = WeatherModel();
                          Weather updatedWeather =
                              await weather.getLocationWeather(
                            type: RequestedWeatherType.Currently,
                            useCelsius: true,
                            latitude: trips[widget.index].location.latitude,
                            longitude: trips[widget.index].location.longitude,
                          );
                          db.updateTripCurrentWeather(
                            docId: trips[widget.index].id,
                            newTemp: updatedWeather.currently.temperature
                                .toStringAsFixed(0),
                            newIcon: updatedWeather.currently.icon,
                          );
                        },
                        iconSize: 24.0,
                        color: Colors.white,
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Hero(
                        tag: 'city-${widget.index}',
                        child: Material(
                          color: Color(0X00FFFFFF),
                          child: Text(
                            trips[widget.index].destination,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'tripName-${widget.index}',
                        child: Material(
                          color: Color(0X00FFFFFF),
                          child: Text(
                            trips[widget.index].name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: 'timer-icon-${widget.index}',
                            child: Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                          ),
                          Hero(
                            tag: 'daysLeft-${widget.index}',
                            child: Material(
                              color: Color(0X00FFFFFF),
                              child: Text(
                                getTripTimeMessage(
                                    context, trips[widget.index]),
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
                        tag: 'startDate-${widget.index}',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
