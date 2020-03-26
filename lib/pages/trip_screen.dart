import 'dart:async';
import 'dart:convert';

import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/currency.dart';
import 'package:book_my_weather/models/currency_rate.dart';
import 'package:book_my_weather/models/networking_state.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/services/currency.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/setting.dart';
import 'package:book_my_weather/services/weather.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum DateType { startDate, endDate }
enum TripActionType { Add, Update }

class TripScreen extends StatefulWidget {
  static const String id = 'trip_screen';
  final Trip existingTrip;

  TripScreen({this.existingTrip});

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  TextEditingController _nameTextEditingController;
  TextEditingController _startDateTextEditingController;
  TextEditingController _endDateTextEditingController;
  TextEditingController _destinationTextEditingController;
  TextEditingController _descriptionTextEditingController;
  final _formKey = GlobalKey<FormState>();
  final _scaffold = GlobalKey();
  String name = '';
  String destination = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String description = '';
  String note = '';
  Timer _throttle;
  List<String> _placeList = [];
  bool showPlaceList = false;

  @override
  void initState() {
    super.initState();
    _nameTextEditingController = TextEditingController();
    _startDateTextEditingController = TextEditingController();
    _endDateTextEditingController = TextEditingController();
    _destinationTextEditingController = TextEditingController();
    _descriptionTextEditingController = TextEditingController();
    _destinationTextEditingController.addListener(_onSearch);
    if (widget.existingTrip != null) {
      final trip = widget.existingTrip;
      setState(() {
        name = trip.name;
        _nameTextEditingController.text = trip.name;
        _descriptionTextEditingController.text = trip.description;
        destination = trip.destination;
        _destinationTextEditingController.text = trip.destination;
        startDate = DateTime.parse(timeStampToISOString(trip.startDate));
        _startDateTextEditingController.text = DateFormat('yMMMMd')
            .format(DateTime.parse(timeStampToISOString(trip.startDate)));
        endDate = DateTime.parse(timeStampToISOString(trip.startDate));
        _endDateTextEditingController.text = DateFormat('yMMMMd')
            .format(DateTime.parse(timeStampToISOString(trip.endDate)));
        description = trip.description;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameTextEditingController.dispose();
    _startDateTextEditingController.dispose();
    _endDateTextEditingController.dispose();
    _descriptionTextEditingController.dispose();
    _destinationTextEditingController.removeListener(_onSearch);
    _destinationTextEditingController.dispose();
  }

  void pickDate(BuildContext context, DateType dateType) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));

    if (pickedDate != null &&
        pickedDate.millisecondsSinceEpoch >=
            DateTime.now().millisecondsSinceEpoch &&
        dateType == DateType.startDate) {
      setState(() {
        _startDateTextEditingController.text =
            DateFormat('yMMMMd').format(pickedDate);
        startDate = pickedDate;
      });
    }

    if (pickedDate != null &&
        pickedDate.millisecondsSinceEpoch >=
            DateTime.now().millisecondsSinceEpoch &&
        dateType == DateType.endDate) {
      setState(() {
        _endDateTextEditingController.text =
            DateFormat('yMMMMd').format(pickedDate);
        endDate = pickedDate;
      });
    }
  }

  void _onSearch() {
    if (_throttle?.isActive ?? false) _throttle.cancel();
    _throttle = Timer(const Duration(milliseconds: 500), () {
      getLocationResults(_destinationTextEditingController.text);
    });
  }

  void getLocationResults(String input) async {
    final result = await gPlaceAutoCompleteResult(input);
    if (this.mounted && result.length > 0 && result[0] != input) {
      setState(() {
        _placeList = result;
      });
    }
  }

  void addOrUpdateTrip(BuildContext context, TripActionType actionType) async {
    final db = DatabaseService();
    String heroImageUrl = '';
    Trip trip;
    final endDateInMs = endDate.millisecondsSinceEpoch;
    final trips = Provider.of<List<Trip>>(context, listen: false);

    final isDateOverlapping = trips
            .where((trip) =>
                widget.existingTrip != null &&
                trip.id != widget.existingTrip.id)
            .where((trip) {
          return (startDate.millisecondsSinceEpoch >=
                      trip.startDate.millisecondsSinceEpoch &&
                  startDate.millisecondsSinceEpoch <= trip.endDateInMs) ||
              (endDate.millisecondsSinceEpoch >=
                      trip.startDate.millisecondsSinceEpoch &&
                  endDate.millisecondsSinceEpoch <= trip.endDateInMs);
        }).length >
        0;
    final isDateRangeInvalid =
        startDate.millisecondsSinceEpoch > endDate.millisecondsSinceEpoch ||
            endDate.millisecondsSinceEpoch < startDate.millisecondsSinceEpoch;

    if (isDateOverlapping) {
      Flushbar(
        messageText: Text(
          'Dates overlapping with another trip already planned. Please pick different dates.',
          style: kSnackbarErrorTextStyle,
        ),
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.warning,
          size: 20.0,
          color: Colors.red,
        ),
        mainButton: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      )..show(context).then((v) => Navigator.pop(context));
    } else if (isDateRangeInvalid) {
      Flushbar(
        messageText: Text(
          'Invalid date range.',
          style: kSnackbarErrorTextStyle,
        ),
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.warning,
          size: 20.0,
          color: Colors.red,
        ),
        mainButton: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      )..show(context).then((v) => Navigator.pop(context));
    } else {
      Currency currency;
      Weather currentWeather;
      Location location;
      WeatherModel weather;
      CurrencyModel currencyModel;
      double currencyRate;
      String currencyCode;
      SettingModel settingModel = SettingModel();
      final currentSetting = settingModel.getCurrentSetting();

      List<String> splitList = destination.split(' ');
      List<String> indexList = [];

      for (int i = 0; i < splitList.length; i++) {
        for (int y = 1; y < splitList[i].length + 1; y++) {
          indexList.add(splitList[i].substring(0, y).toLowerCase());
        }
      }

      try {
        location = Location();
        await location.getPlaceMarkFromAddress(address: destination);
      } catch (e) {
        displayErrorSnackbarWithSilentAction(
          context,
          'Error getting destination address.',
          (v) => Navigator.pop(context),
        );
        return;
      }

      try {
        weather = WeatherModel();
        currentWeather = await weather.getLocationWeather(
          type: RequestedWeatherType.Currently,
          useCelsius: currentSetting.useCelsius,
          latitude: location.latitude,
          longitude: location.longitude,
        );
      } catch (e) {
        displayErrorSnackbarWithSilentAction(
          context,
          'Error getting destination weather.',
          (v) => Navigator.pop(context),
        );
        return;
      }

      try {
        currencyModel = CurrencyModel();
        currency = await currencyModel.getSingleCurrencyCode(
            location.latitude, location.longitude);
        CurrencyRate result =
            await currencyModel.getCurrencyRate(currency.code);
        currencyRate = result.rate;
      } catch (e) {
        displayErrorSnackbarWithSilentAction(
            context,
            'Error getting destination currency rate.',
            (v) => Navigator.pop(context));
        return;
      }

      if (actionType == TripActionType.Add) {
        http.Response response =
            await http.get('$kUnsplashAPIURL&query=$destination');

        if (response.statusCode == 200) {
          heroImageUrl = jsonDecode(response.body)[0]['urls']['regular'];
        }

        trip = Trip(
          createdByUid: Provider.of<User>(context, listen: false).uid,
          name: name,
          destination: destination,
          description: description,
          startDate: Timestamp.fromDate(startDate),
          endDate: Timestamp.fromDate(endDate),
          location: GeoPoint(location.latitude, location.longitude),
          heroImages: [heroImageUrl],
          temperature: currentWeather.currently.temperature.toStringAsFixed(0),
          weatherIcon: currentWeather.currently.icon,
          searchIndex: indexList,
          endDateInMs: endDateInMs,
          currencyRate: currencyRate,
          currencyCode: currency.code,
        );

        try {
          await db.addTrip(trip);
          Navigator.pop(context);
          Navigator.pop(context);
        } on PlatformException catch (e) {
          Navigator.pop(context);
          Provider.of<NetworkingState>(context, listen: false)
              .setMessage(e.details);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              Provider.of<NetworkingState>(context, listen: false).message,
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.0,
              ),
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                Provider.of<NetworkingState>(context, listen: false).reset();
              },
            ),
          ));
        }
      } else {
        trip = Trip(
          createdByUid: Provider.of<User>(context, listen: false).uid,
          name: name,
          destination: destination,
          description: description,
          startDate: Timestamp.fromDate(startDate),
          endDate: Timestamp.fromDate(endDate),
          location: GeoPoint(location.latitude, location.longitude),
          temperature: currentWeather.currently.temperature.toStringAsFixed(0),
          weatherIcon: currentWeather.currently.icon,
          searchIndex: indexList,
          endDateInMs: endDateInMs,
          currencyRate: currencyRate,
          currencyCode: currency.code,
        );
        try {
          await db.updateTrip(docId: widget.existingTrip.id, updatedTrip: trip);
          Navigator.pop(context);
          Navigator.pop(context);
        } on PlatformException catch (e) {
          Navigator.pop(context);
          Provider.of<NetworkingState>(context, listen: false)
              .setMessage(e.details);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              Provider.of<NetworkingState>(context, listen: false).message,
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.0,
              ),
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                Provider.of<NetworkingState>(context, listen: false).reset();
              },
            ),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffold,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Builder(
            builder: (BuildContext context) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          iconSize: 40,
                          padding: EdgeInsets.all(0.0),
                          alignment: Alignment.centerLeft,
                          icon: Icon(Icons.close),
                          color: Colors.white.withOpacity(0.9),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          iconSize: 40.0,
                          icon: Icon(Icons.save),
                          color: Color(0XFF69A4FF),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return SpinKitWave(
                                      color: Colors.white,
                                      size: 50.0,
                                    );
                                  });
                              if (widget.existingTrip == null) {
                                addOrUpdateTrip(context, TripActionType.Add);
                              } else {
                                addOrUpdateTrip(context, TripActionType.Update);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.existingTrip != null ? 'Edit Trip' : 'New Trip',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 40.0,
                        color: Color(0XFF69A4FF),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: TextFormField(
                              controller: _nameTextEditingController,
                              style: kTextFieldStyle,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a name' : null,
                              onChanged: (String newValue) {
                                setState(() {
                                  name = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle: TextStyle(
                                  color: Color(0XFF436DA6),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w100,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0XFF69A4FF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: TextFormField(
                              style: kTextFieldStyle,
                              controller: _destinationTextEditingController,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a destination' : null,
                              onChanged: (String newValue) {
                                setState(() {
                                  destination = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Destination',
                                hintStyle: TextStyle(
                                  color: Color(0XFF436DA6),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w100,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0XFF69A4FF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: TextFormField(
                              style: kTextFieldStyle,
                              controller: _startDateTextEditingController,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a start date' : null,
                              onTap: () async {
                                pickDate(context, DateType.startDate);
                              },
                              decoration: InputDecoration(
                                hintText: 'Start Date',
                                hintStyle: TextStyle(
                                  color: Color(0XFF436DA6),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w100,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0XFF69A4FF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: TextFormField(
                              controller: _endDateTextEditingController,
                              style: kTextFieldStyle,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an end date' : null,
                              onTap: () {
                                pickDate(context, DateType.endDate);
                              },
                              decoration: InputDecoration(
                                hintText: 'End Date',
                                hintStyle: TextStyle(
                                  color: Color(0XFF436DA6),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w100,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0XFF69A4FF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: TextFormField(
                              controller: _descriptionTextEditingController,
                              style: kTextFieldStyle,
                              onChanged: (String newValue) {
                                setState(() {
                                  description = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Description',
                                hintStyle: TextStyle(
                                  color: Color(0XFF436DA6),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w100,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0XFF69A4FF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_placeList.length > 0 &&
                        _placeList[0] != _destinationTextEditingController.text)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _placeList.length,
                          itemBuilder:
                              (BuildContext listViewBuilderContext, int index) {
                            return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _destinationTextEditingController.text =
                                      _placeList[index];
                                  destination = _placeList[index];
                                });
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
