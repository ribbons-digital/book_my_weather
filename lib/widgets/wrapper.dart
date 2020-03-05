import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/pages/place_detail_screen.dart';
import 'package:book_my_weather/pages/places_screen.dart';
import 'package:book_my_weather/pages/search_place_screen.dart';
import 'package:book_my_weather/pages/signin_register_screen.dart';
import 'package:book_my_weather/pages/trip_detail_screen.dart';
import 'package:book_my_weather/pages/trip_screen.dart';
import 'package:book_my_weather/pages/trips_screen.dart';
import 'package:book_my_weather/pages/weather_listing_screen.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  final bool isIos;
  Wrapper({this.isIos});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 0;
  Future<String> deviceId;
  String filterString;
  bool isPast = false;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w100);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    deviceId = getDeviceId();
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (widget.isIos) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }

  void setFilterStringForTrips(String newString) {
    setState(() {
      filterString = newString;
    });
  }

  void setIsPast(bool value) {
    setState(() {
      isPast = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
//    final auth = AuthService();

    return FutureBuilder(
      future: deviceId,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<PlaceData>(
                create: (_) => PlaceData(),
              ),
              StreamProvider<Setting>.value(
                value: db.streamSetting(snapshot.data),
              ),
              StreamProvider<List<Trip>>.value(
                  value: db.streamTrips(
                uid: Provider.of<User>(context) != null
                    ? Provider.of<User>(context).uid
                    : '',
                filterString: filterString,
                isPast: isPast,
              )),
            ],
            child: Consumer<PlaceData>(
              builder: (_, placeData, __) => MaterialApp(
                title: 'Book My Weather',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Colors.white,
                  canvasColor: Colors.black,
                  appBarTheme: AppBarTheme(
                    elevation: 0,
                    color: Colors.black,
                    iconTheme: IconThemeData(
                      color: Colors.white,
                      size: 30.0,
                    ),
                    textTheme: TextTheme(
                      title: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                ),
//                navigatorObservers: [MyRouteObserver()],
                home: Scaffold(
                  body: IndexedStack(
                    index: _selectedIndex,
                    children: <Widget>[
                      WeatherListingScreen(
                        places: placeData.places,
                        deviceId: snapshot.data,
                        // setting: setting,
                      ),
                      TripsScreen(
                        setFilterString: setFilterStringForTrips,
                        setIsPast: setIsPast,
                      )
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: Colors.white,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.wb_sunny),
                        title: Text('Home'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.map),
                        title: Text('Trips'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        title: Text('Saved'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        title: Text('Settings'),
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.amber[800],
                    onTap: _onItemTapped,
                  ),
                ),
                routes: {
                  TripScreen.id: (context) => TripScreen(),
                  TripDetail.id: (context) => TripDetail(),
                  PlacesScreen.id: (context) => PlacesScreen(),
                  PlaceDetail.id: (context) => PlaceDetail(),
                  SearchPlaceScreen.id: (context) => SearchPlaceScreen(),
                  TripsScreen.id: (context) => TripsScreen(),
                  SignInRegisterScreen.id: (context) => SignInRegisterScreen(),
                },
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('${snapshot.error.toString()}');
        }

        return Container();
      },
    );
  }
}

//class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
//  void _sendScreenView(PageRoute<dynamic> route) {
//    var screenName = route.settings.name;
//    print('screenName $screenName');
//    // do something with it, ie. send it to your analytics service collector
//  }
//
//  @override
//  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
//    super.didPush(route, previousRoute);
//    if (route is PageRoute) {
//      _sendScreenView(route);
//    }
//  }
//
//  @override
//  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
//    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//    if (newRoute is PageRoute) {
//      _sendScreenView(newRoute);
//    }
//  }
//
//  @override
//  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
//    super.didPop(route, previousRoute);
//    if (previousRoute is PageRoute && route is PageRoute) {
//      _sendScreenView(previousRoute);
//    }
//  }
//}
