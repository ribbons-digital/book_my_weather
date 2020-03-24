import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/services/auth.dart';
import 'package:book_my_weather/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final auth = AuthService();
    return StreamProvider<User>.value(
      value: auth.user,
      child: Wrapper(isIos: isIos),
    );
  }
}
