import 'package:book_my_weather/services/auth.dart';
import 'package:flutter/material.dart';

class SignInRegisterScreen extends StatefulWidget {
  @override
  _SignInRegisterScreenState createState() => _SignInRegisterScreenState();
}

class _SignInRegisterScreenState extends State<SignInRegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  bool isSignIn = true;

  void toggleIsSignIn() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Sign in or Register', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w200,
        ),),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
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
              RaisedButton(
                  color: Color(0XFF69A4FF),
                  child: Text(
                    isSignIn ? 'Sign In' : 'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result;
                      if (isSignIn) {
                        result = await _auth.signInWithEmailAndPassword(
                            email, password);
                      } else {
                        result = await _auth.registerWithEmailAndPassword(
                            email, password);
                      }

                      if (result != null) {
                        Navigator.pop(context);
                      } else {
                        print(result.toString());
                      }
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(isSignIn ? 'No account yet?' : 'Already registered?', style: TextStyle(
                    color: Colors.white,
                  ),),
                  FlatButton(
                    child: Text(isSignIn ? 'Register' : 'Log in', style: TextStyle(
                    color: Color(0XFF69A4FF),
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),),
                    onPressed: toggleIsSignIn,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
