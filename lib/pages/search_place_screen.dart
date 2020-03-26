import 'dart:async';

import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/setting.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';

class SearchPlaceScreen extends StatefulWidget {
  static const String id = 'searchPlace';

  @override
  _SearchPlaceScreenState createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  TextEditingController _textEditingController;
  Timer _throttle;
  List<String> _placeList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(_onSearch);
  }

  void _onSearch() {
    if (_throttle?.isActive ?? false) _throttle.cancel();
    _throttle = Timer(const Duration(milliseconds: 500), () {
      getLocationResults(_textEditingController.text);
    });
  }

  void getLocationResults(String input) async {
    if (input.length > 0) {
      if (this.mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final result = await gPlaceAutoCompleteResult(input);
      if (this.mounted) {
        setState(() {
          _placeList = result;
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onSearch);
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settings');
    List<Place> places = (settingsBox.get(0) as Setting).places;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: SafeArea(
        child: Container(
//          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Builder(
            builder: (BuildContext context) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width - 30,
                    color: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            decoration: InputDecoration(),
                            autofocus: true,
                            controller: _textEditingController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? Expanded(
                          child: SpinKitWave(
                            color: Colors.white,
                            size: 50.0,
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _placeList.length,
                            itemBuilder: (BuildContext listViewBuilderContext,
                                int index) {
                              return GestureDetector(
                                onTap: () async {
                                  Location location = Location();
                                  WeatherModel weather = WeatherModel();
                                  SettingModel settingModel = SettingModel();
                                  final currentSetting =
                                      settingModel.getCurrentSetting();
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await location.getPlaceMarkFromAddress(
                                        address: _placeList[index]);

                                    Weather currentPlaceWeather =
                                        await weather.getLocationWeather(
                                      type: RequestedWeatherType.All,
                                      useCelsius: currentSetting.useCelsius,
                                      latitude: location.latitude,
                                      longitude: location.longitude,
                                    );

                                    final isAlreadyExist = places
                                            .where((e) =>
                                                e.address ==
                                                    location.placeMark[0]
                                                        .locality ||
                                                e.address ==
                                                    location.placeMark[0].name)
                                            .length >
                                        0;

                                    if (isAlreadyExist) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      displayErrorSnackbar(context,
                                          'You have previously added this place.');
                                    } else {
                                      final newPlace = Place(
                                        name: location.placeMark[0].name,
                                        address:
                                            location.placeMark[0].name == ''
                                                ? location.placeMark[0].locality
                                                : location.placeMark[0].name,
                                        latitude: location.latitude,
                                        longitude: location.longitude,
                                        weather: currentPlaceWeather,
                                      );

                                      addPlaceToSetting(newPlace);

                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        e.toString(),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: double.infinity,
                                    height: 65.0,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${_placeList[index]}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
