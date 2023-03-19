import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/models/database.dart';
import 'package:konigle_mobile_app/pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/userModel.dart';

/**
 * Login page for existing users. Accepts username and password.
 */
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;
  Database db = Database();

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 116, 30, 1),
        title: Text('Login', style: TextStyle(color: Colors.white),),
      ),
      body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: !_showPassword,
                ),
                SizedBox(height: 32,),
                ElevatedButton(
                  child: Text('Login', style: TextStyle(fontSize: 20),),
                  onPressed: _login,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a Member?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Color.fromRGBO(238, 116, 30, 1)  // Custom Colors to match Konigle Icon
                        ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (builder) => SignUpPage()
                            ));
                          },
                          child: Text(
                              "SIGN UP!",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(238, 116, 30, 1)
                            ),
                          )
                      )
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  /**
   * Login Logic implemented using SharedPreferences to store logged in user.
   */
  void _login() async {
    setState(() {
      _isLoading = true;
    });
    User response = db.getUser(_usernameController.text, _passwordController.text);
    if (response != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLogin", true);
      prefs.setInt("user", response.id);
      Navigator.popAndPushNamed(context, "/home");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Credentials'),
            content: Text('Please enter valid username and password.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isLoading = false;
                  });
                },
              )
            ],
          );
        },
      );
    }
  }
}