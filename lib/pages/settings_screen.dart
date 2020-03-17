import 'package:book_my_weather/services/auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: FlatButton(
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              final _auth = AuthService();
              _auth.signOut();
            },
          ),
        ),
      ),
    );
  }
}
