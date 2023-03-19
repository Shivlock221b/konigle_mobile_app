import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/models/database.dart';
import 'package:konigle_mobile_app/models/userModel.dart';
import 'package:konigle_mobile_app/pages/home.dart';
import 'package:konigle_mobile_app/pages/login.dart';
import 'package:konigle_mobile_app/pages/signup.dart';
import 'package:konigle_mobile_app/pages/splash.dart';
import 'package:konigle_mobile_app/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogin = false;
User? user;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Static method for initialise database. Local Database stored in shared preferences
  // An alternative would be sqflite. Although that would use more storage on user end.
  // Best would be to store Database on server side.
  await Database.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLogin = prefs.getBool("isLogin") ?? false;
  if (isLogin) {
    // Static method used to get user info by index. Only used if the user in already logged in on the device.
    user = Database.getUserByIndex(prefs.getInt("index")!);
  }

  // Multi Provider used to integrate more providers in the future
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: MyApp(),
  ));
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
      home: SplashScreen(isLogin: isLogin,),
      routes: {
        "/login" : (context) => LoginPage(),
        "/home" : (context) => HomePage(),
        "/signup": (context) => SignUpPage()
      }
    );
  }
}
