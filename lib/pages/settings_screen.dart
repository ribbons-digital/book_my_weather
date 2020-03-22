import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/pages/signin_register_screen.dart';
import 'package:book_my_weather/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          child: Column(
            children: <Widget>[
              if (!isLoggedIn)
                FlatButton(
                  child: Text(
                    'Sign in',
                    style: textStyle,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, SignInRegisterScreen.id);
                  },
                ),
              if (!isLoggedIn)
                Divider(color: Colors.blueGrey,),
              if (isLoggedIn)
                Text('Logged in as ${user.email}', style: textStyle,),
              if (isLoggedIn)
                Divider(color: Colors.blueGrey,),
              if (isLoggedIn)
                FlatButton(
                  color: Colors.blueGrey,
                  child: Text(
                    'Sign Out',
                    style: textStyle,
                  ),
                  onPressed: () {
                    final _auth = AuthService();
                    _auth.signOut();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
