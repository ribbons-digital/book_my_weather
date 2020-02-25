import 'package:book_my_weather/models/place_data.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/models/setting_data.dart';
import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/pages/new_trip_screen.dart';
import 'package:book_my_weather/pages/place_detail_screen.dart';
import 'package:book_my_weather/pages/places_screen.dart';
import 'package:book_my_weather/pages/search_place_screen.dart';
import 'package:book_my_weather/pages/trip_detail_screen.dart';
import 'package:book_my_weather/pages/weather_listing_screen.dart';
import 'package:book_my_weather/services/auth.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/trips_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w100);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Trips',
      style: optionStyle,
    ),
    Text(
      'Index 2: Saved',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final auth = AuthService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlaceData>(
          create: (_) => PlaceData(),
        ),
        ChangeNotifierProvider<SettingData>(
          create: (_) => SettingData(),
        ),
        StreamProvider<Setting>.value(
          value: db.streamSetting('9g6UjX6R9CP5KEc9PQ1r'),
        ),
       StreamProvider<User>.value(
         value: auth.user,
       ),
      ],
      child: Consumer<PlaceData>(
        builder: (_, placeData, __) => MaterialApp(
            title: 'Despicable Me Characters',
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
            home: Scaffold(
              body: IndexedStack(
                index: _selectedIndex,
                children: <Widget>[
                  //  StreamProvider<Setting>.value(
                  //    value: db.streamSetting('9g6UjX6R9CP5KEc9PQ1r'),
                  //    child: WeatherListingScreen(
                  //      places: placeData.places,
                  //    ),
                  //  ),
                  WeatherListingScreen(
                    places: placeData.places,
                    // setting: setting,
                  ),
                  TripsScreen()
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
              NewTrip.id: (context) => NewTrip(),
              TripDetail.id: (context) => TripDetail(),
              PlacesScreen.id: (context) => PlacesScreen(),
              PlaceDetail.id: (context) => PlaceDetail(),
              SearchPlaceScreen.id: (context) => SearchPlaceScreen(),
            },
          ),
      ),
    );
  }
}
