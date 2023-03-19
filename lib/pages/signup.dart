import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/main.dart';
import 'package:konigle_mobile_app/models/database.dart';
import 'package:konigle_mobile_app/models/userModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/userProvider.dart';
import 'home.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool usernameValidate = true;
  bool emailValidate = true;
  bool validate = true;
  Database db = Database();
  User? user;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<Map> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      user = User(id: db.getLength(), name: _usernameController.text, email: _emailController.text, password: _passwordController.text, chapterProgress: []);
      Map response = await db.setUser(user!);
      return response;
    } else {
      return {"status": 500, "message": "Error: Something went wrong. Please check the details and try again."};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    usernameValidate = true;
                  });
                },
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  Map result = await _submitForm();
                  if (result['status'] == 200) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool("isLogin", true);
                    prefs.setInt("index", user!.id);
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, "/home");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message']),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
