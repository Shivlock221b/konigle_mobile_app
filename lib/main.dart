import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/models/database.dart';
import 'package:konigle_mobile_app/pages/home.dart';
import 'package:konigle_mobile_app/pages/login.dart';
import 'package:konigle_mobile_app/pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogin = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLogin = prefs.getBool("isLogin") ?? false;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLogin ? HomePage() : LoginPage(),
    );
  }
}
