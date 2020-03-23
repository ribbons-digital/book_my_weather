import 'package:book_my_weather/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, email: user.email, displayName: user.displayName)
        : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser firebaseUser) {
      return _userFromFirebaseUser(firebaseUser);
    });
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user);
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
