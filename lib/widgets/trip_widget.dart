import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/services/setting.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripWidget extends StatefulWidget {
  final Trip pastTrip;
  final int index;

  TripWidget({
    this.pastTrip,
    @required this.index,
  });
  @override
  _TripWidgetState createState() => _TripWidgetState();
}

class _TripWidgetState extends State<TripWidget> {
  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    final trip = widget.pastTrip ?? Provider.of<List<Trip>>(context)[index];
    final startDateToDateString = timeStampToDateString(trip.startDate);

    WeatherModel weatherModel = WeatherModel();
    SettingModel settingModel = SettingModel();
    final currentSetting = settingModel.getCurrentSetting();

    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width - 40
            : MediaQuery.of(context).size.width - 100,
        height: 160,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
                tag: 'tripItem-$index',
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.black,
                  ),
                )),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Hero(
                tag: 'city-img-$index',
                child: Opacity(
                  opacity: 0.6,
                  child: Image.network(
                    trip.heroImages[0],
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
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: 'currencyIcon-$index',
                            child: Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                            ),
                          ),
                          Hero(
                            tag: 'currency-$index',
                            child: Material(
                              color: Color(0X00FFFFFF),
                              child: Text(
                                trip != null
                                    ? '1 ${currentSetting.baseSymbol} = ${trip.currencyRate.toStringAsFixed(2)} ${trip.currencyCode}'
                                    : '---',
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
                  Column(
                    children: <Widget>[
                      Hero(
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
                      Hero(
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
                    ],
                  ),
                  Row(
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
                            tag: 'daysLeft-$index',
                            child: Material(
                              color: Color(0X00FFFFFF),
                              child: Text(
                                getTripTimeMessage(context, trip),
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
                        tag: 'startDate-$index',
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
