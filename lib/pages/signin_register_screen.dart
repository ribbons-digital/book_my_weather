import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/services/auth.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignInRegisterScreen extends StatefulWidget {
  static const String id = 'signInRegister';
  @override
  _SignInRegisterScreenState createState() => _SignInRegisterScreenState();
}

class _SignInRegisterScreenState extends State<SignInRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Sign in or Register',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: _SignInRegisterForm(),
      ),
    );
  }
}

class _SignInRegisterForm extends StatefulWidget {
  @override
  __SignInRegisterFormState createState() => __SignInRegisterFormState();
}

class __SignInRegisterFormState extends State<_SignInRegisterForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  bool isSignIn = true;
  bool isLoading = false;

  void toggleIsSignIn() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 24.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Email',
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
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 24.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Password',
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
                validator: (val) =>
                    val.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              if (isLoading)
                SpinKitCircle(
                  color: Colors.white,
                  size: 20.0,
                ),
              if (!isLoading)
                RaisedButton(
                    color: Color(0XFF69A4FF),
                    child: Text(
                      isSignIn ? 'Sign In' : 'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        dynamic result;
                        if (isSignIn) {
                          result = await _auth.signInWithEmailAndPassword(
                              email, password);
                        } else {
                          result = await _auth.registerWithEmailAndPassword(
                              email, password);
                        }

                        if (result is User) {
                          final FirebaseMessaging _fcm = FirebaseMessaging();
                          final _db = DatabaseService();
                          String token = await _fcm.getToken();
                          if (!isSignIn) {
                            if (token != null) {
                              await _db.setUserDeviceToken(
                                  token: token, uid: result.uid);
                            }
                          } else {
                            final isTokenExist =
                                await _db.checkExistingDeviceToken(
                                    token: token, uid: result.uid);
                            if (!isTokenExist) {
                              await _db.setUserDeviceToken(
                                  token: token, uid: result.uid);
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        } else if (result is String) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                              result,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15.0,
                              ),
                            ),
                          ));
                        }
                      }
                    }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    isSignIn ? 'No account yet?' : 'Already registered?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      isSignIn ? 'Register' : 'Log in',
                      style: TextStyle(
                        color: Color(0XFF69A4FF),
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: toggleIsSignIn,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
