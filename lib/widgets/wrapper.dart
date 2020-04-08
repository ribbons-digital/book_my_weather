import 'package:book_my_weather/app_localizations.dart';
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
import 'package:flutter_localizations/flutter_localizations.dart';
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
  String filterString;

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
  }

  void setFilterStringForTrips(String newString) {
    setState(() {
      filterString = newString;
    });
  }

  Widget renderScreen() {
    if (_selectedIndex == 0) {
      return WeatherListingScreen();
    }

    if (_selectedIndex == 1) {
      return TripsScreen(
        setFilterString: setFilterStringForTrips,
        filterString: filterString,
      );
    }

    if (_selectedIndex == 2) {
      return NewsScreen(
        selectHomeIndex: _onItemTapped,
      );
    }

    if (_selectedIndex == 3) {
      return SettingsScreen();
    }

    return Container();
  }

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
      child: MaterialApp(
        title: 'Book My Weather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Raleway',
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
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale.fromSubtags(languageCode: 'zh'), // generic Chinese 'zh'
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
          const Locale.fromSubtags(
              languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
        ],
        // These delegates make sure that the localization data for the proper language is loaded
        localizationsDelegates: [
          // THIS CLASS WILL BE ADDED LATER
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
        home: FutureBuilder(
          future: Hive.openBox('settings'),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Text(
                snapshot.error.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData)
              return Scaffold(
                body: renderScreen(),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.wb_sunny),
                      title: Text('Weather'),
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
    );
  }
}
