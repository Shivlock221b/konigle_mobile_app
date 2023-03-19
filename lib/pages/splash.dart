import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/pages/home.dart';
import 'package:konigle_mobile_app/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.isLogin}) : super(key: key);
  final bool isLogin;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 2500), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward().then((_) {
      navigationPage();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void navigationPage() {
    // Navigator.of(context)
    //     .pushReplacement(MaterialPageRoute(builder: (_) => widget.isLogin ? HomeScreen() : Body()));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => widget.isLogin ? HomePage() : LoginPage()));
  }

  Widget build(BuildContext context) {

    return Container(

      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: new Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Opacity(
                      opacity: opacity.value,
                      child: new Image.asset('assets/images/konigle.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'Powered by '),
                          TextSpan(
                              text: 'Orion',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
