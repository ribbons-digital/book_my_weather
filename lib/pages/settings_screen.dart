import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/pages/signin_register_screen.dart';
import 'package:book_my_weather/services/auth.dart';
import 'package:book_my_weather/services/currency.dart';
import 'package:book_my_weather/services/setting.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<bool> _selections = List.generate(2, (_) => false);
  Future<List<String>> _currencyList;
  String _selectedCurrency;

  Future<List<String>> _getCurrencyList() async {
    SettingModel settingModal = SettingModel();
    CurrencyModel currencyModel = CurrencyModel();
    Setting currentSetting = settingModal.getCurrentSetting();
    if (currentSetting != null) {
      setState(() {
        _selections = currentSetting.useCelsius ? [true, false] : [false, true];
        _selectedCurrency = currentSetting.baseSymbol;
      });
    }

    return await currencyModel.getCurrencyCodes();
  }

  @override
  void initState() {
    super.initState();
    _currencyList = _getCurrencyList();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<User>(context) != null;
    final user = Provider.of<User>(context);
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w200,
    );

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: !isLoggedIn
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    FlatButton(
                      color: Color(
                        0XFF69A4FF,
                      ),
                      child: Text(
                        'Sign in',
                        style: textStyle,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SignInRegisterScreen.id);
                      },
                    ),
                    Divider(
                      color: Colors.blueGrey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Weather service ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Powered by Dark Sky',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final url =
                                        'https://darksky.net/poweredby/';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Something is wrong';
                                    }
                                  })
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : FutureBuilder(
                  future: _currencyList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SpinKitWave(
                        size: 50.0,
                        color: Colors.white,
                      );
                    }

                    if ((snapshot.connectionState == ConnectionState.done ||
                            snapshot.connectionState == ConnectionState.none) &&
                        snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Logged in as ${user.email}',
                            style: textStyle,
                          ),
                          Divider(
                            color: Colors.blueGrey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Set base currency:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: DropdownButton<String>(
                                    value: _selectedCurrency,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24.0),
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 36,
                                    items: snapshot.data
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String selectedCurrency) {
                                      SettingModel settingModal =
                                          SettingModel();
                                      settingModal.updateBaseCurrencyInSetting(
                                          selectedCurrency);
                                      setState(() {
                                        _selectedCurrency = selectedCurrency;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.blueGrey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Temperature unit:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                ToggleButtons(
                                  children: <Widget>[
                                    Text(
                                      'ºC',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'ºF',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                  isSelected: _selections,
                                  color: Colors.white,
                                  selectedColor: Color(0xFFFFA500),
                                  fillColor: Color(
                                    0XFF69A4FF,
                                  ),
                                  onPressed: (int index) {
                                    SettingModel settingModal = SettingModel();
                                    setState(() {
                                      if (index == 0) {
                                        settingModal
                                            .updateTempUnitInSetting(true);
                                        _selections[0] = true;
                                        _selections[1] = false;
                                      } else {
                                        settingModal
                                            .updateTempUnitInSetting(false);
                                        _selections[0] = false;
                                        _selections[1] = true;
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.blueGrey,
                          ),
                          FlatButton(
                            color: Color(
                              0XFF69A4FF,
                            ),
                            child: Text(
                              'Sign Out',
                              style: textStyle,
                            ),
                            onPressed: () {
                              final _auth = AuthService();
                              _auth.signOut();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Weather service ',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Powered by Dark Sky',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final url =
                                              'https://darksky.net/poweredby/';
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Something is wrong';
                                          }
                                        })
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        snapshot.error.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }

                    return Container();
                  },
                ),
        ),
      ),
    );
  }
}
