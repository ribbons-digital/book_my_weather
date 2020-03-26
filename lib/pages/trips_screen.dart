import 'package:book_my_weather/models/currency_rate.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/pages/signin_register_screen.dart';
import 'package:book_my_weather/pages/trip_detail_screen.dart';
import 'package:book_my_weather/pages/trip_screen.dart';
import 'package:book_my_weather/services/currency.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/services/setting.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/widgets/trip_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TripsScreen extends StatefulWidget {
  static const String id = 'trips';
  final Function setFilterString;
  final Function setIsPast;

  TripsScreen({@required this.setFilterString, @required this.setIsPast});

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  TextEditingController _textEditingController;

  String dropdownValue = 'Upcoming';

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
    final db = DatabaseService();

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
                      if (newValue == 'Upcoming') {
                        widget.setIsPast(false);
                      } else {
                        widget.setIsPast(true);
                      }
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
                        Navigator.pushNamed(context, TripScreen.id);
                      } else {
                        Navigator.pushNamed(context, SignInRegisterScreen.id);
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
              onChanged: (String newValue) {
                widget.setFilterString(newValue);
              },
              style: TextStyle(
                fontSize: 22.0,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                hintText: 'Search by destination',
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
          (trips == null || trips.length == 0 || user == null) &&
                  dropdownValue == 'Upcoming'
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
          (trips == null || trips.length == 0 || user == null) &&
                  dropdownValue == 'Upcoming'
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
          if (trips != null && trips.length > 0 && user != null)
            Expanded(
              child: ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      child: GestureDetector(
                        onTap: () {
//                    Navigator.pushNamed(context, TripDetail.id);
                          Provider.of<TripState>(context, listen: false)
                              .updateSelectedTrip(index, trips[index]);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 550),
                              pageBuilder: (context, _, __) => TripDetail(),
                              transitionsBuilder: (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child,
                              ) =>
                                  ScaleTransition(
                                scale: Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.fastOutSlowIn,
                                  ),
                                ),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: TripWidget(
                          index: index,
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Refresh',
                          color: Colors.blue,
                          icon: Icons.refresh,
                          onTap: () async {
                            WeatherModel weather = WeatherModel();
                            SettingModel settingModel = SettingModel();
                            final currentSetting =
                                settingModel.getCurrentSetting();
                            Weather updatedWeather =
                                await weather.getLocationWeather(
                              type: RequestedWeatherType.Currently,
                              useCelsius: currentSetting.useCelsius,
                              latitude: trips[index].location.latitude,
                              longitude: trips[index].location.longitude,
                            );
                            await db.updateTripCurrentWeather(
                              docId: trips[index].id,
                              newTemp: updatedWeather.currently.temperature
                                  .toStringAsFixed(0),
                              newIcon: updatedWeather.currently.icon,
                            );

                            CurrencyModel currencyModel = CurrencyModel();
                            CurrencyRate currency = await currencyModel
                                .getCurrencyRate(trips[index].currencyCode);
                            await db.updateTripCurrency(
                              docId: trips[index].id,
                              currencyCode: trips[index].currencyCode,
                              currencyRate: currency.rate,
                            );
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            await db.deleteTrip(docId: trips[index].id);
                          },
                        ),
                      ],
                    );
                  }),
            ),
          if ((trips == null || trips.length == 0 || user == null) &&
              dropdownValue == 'Upcoming')
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Opacity(
                        opacity: 0.7,
                        child: Image.asset(
                          'assets/images/Hot_Air_Ballon.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
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
