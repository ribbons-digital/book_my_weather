import 'package:book_my_weather/models/networking_state.dart';
import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/pages/news_screen.dart';
import 'package:book_my_weather/pages/place_detail_screen.dart';
import 'package:book_my_weather/pages/places_screen.dart';
import 'package:book_my_weather/pages/search_place_screen.dart';
import 'package:book_my_weather/pages/settings_screen.dart';
import 'package:book_my_weather/pages/signin_register_screen.dart';
import 'package:book_my_weather/pages/trip_detail_screen.dart';
import 'package:book_my_weather/pages/trip_screen.dart';
import 'package:book_my_weather/pages/trip_todos_screen.dart';
import 'package:book_my_weather/pages/trip_visiting_screen.dart';
import 'package:book_my_weather/pages/trip_weather_screen.dart';
import 'package:book_my_weather/pages/trips_screen.dart';
import 'package:book_my_weather/pages/weather_listing_screen.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  final bool isIos;
  Wrapper({this.isIos});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 0;
//  Future<String> deviceId;
  String filterString;
//  bool isPast = false;

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
//    deviceId = getDeviceId();
  }

//  Future<String> getDeviceId() async {
//    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//
//    if (widget.isIos) {
//      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
//      return iosDeviceInfo.identifierForVendor;
//    } else {
//      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
//      return androidDeviceInfo.androidId;
//    }
//  }

  void setFilterStringForTrips(String newString) {
    setState(() {
      filterString = newString;
    });
  }

//  void setIsPast(bool value) {
//    setState(() {
//      isPast = value;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlaceData>(
          create: (_) => PlaceData(),
        ),
        ChangeNotifierProvider<TripState>(
          create: (_) => TripState(),
        ),
        ChangeNotifierProvider<NetworkingState>(
          create: (_) => NetworkingState(),
        ),
        StreamProvider<List<Trip>>.value(
          value: db.streamUpcomingTrips(
            uid: Provider.of<User>(context) != null
                ? Provider.of<User>(context).uid
                : '',
            filterString: filterString,
          ),
        ),
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
              brightness: Brightness.dark,
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
          home: FutureBuilder(
            future: Hive.openBox('settings'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) if (snapshot
                  .hasError)
                return Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              else
                return Scaffold(
                  body: IndexedStack(
                    index: _selectedIndex,
                    children: <Widget>[
                      WeatherListingScreen(),
                      TripsScreen(
                        setFilterString: setFilterStringForTrips,
                        filterString: filterString,
                      ),
                      NewsScreen(
                        selectHomeIndex: _onItemTapped,
                      ),
                      SettingsScreen(),
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
                        icon: Icon(Icons.public),
                        title: Text('News'),
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
                );
              else
                return Scaffold();
            },
          ),
          routes: {
            TripScreen.id: (context) => TripScreen(),
            TripDetail.id: (context) => TripDetail(),
            PlacesScreen.id: (context) => PlacesScreen(),
            PlaceDetail.id: (context) => PlaceDetail(),
            SearchPlaceScreen.id: (context) => SearchPlaceScreen(),
            TripsScreen.id: (context) => TripsScreen(),
            SignInRegisterScreen.id: (context) => SignInRegisterScreen(),
            TripWeatherScreen.id: (context) => TripWeatherScreen(),
            TripTodosScreen.id: (context) => TripTodosScreen(),
            TripVisitingScreen.id: (context) => TripVisitingScreen(),
          },
        ),
      ),
    );
  }
}
