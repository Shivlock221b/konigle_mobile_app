import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  RaisedButton(
                    child: Text('Login'),
                    onPressed: _login,
                  ),
                ],
              ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // Here you can add your own authentication logic to verify the user's credentials.
    // For simplicity, we'll just use a shared preferences-based authentication.

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username')!;
    String password = prefs.getString('password')!;

    if (_usernameController.text == username &&
        _passwordController.text == password) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Credentials'),
            content: Text('Please enter valid username and password.'),
            actions: <Widget>[
              FlatButton(
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Chapter> _chapters = [
    Chapter(
      title: 'Chapter 1',
      sections: [
        Section(
          title: 'Section 1',
          text: 'This is section 1 of chapter 1.',
          image: 'assets/images/chapter1_section1.jpg',
        ),
        Section(
          title: 'Section 2',
          text: 'This is section 2 of chapter 1.',
          image: 'assets/images/chapter1_section2.jpg',
        ),
      ],
    ),
    Chapter(
      title: 'Chapter 2',
      sections: [
        Section(
          title: 'Section 1',
          text: 'This is section 1 of chapter 2.',
          image: 'assets/images/chapter2_section1.jpg',
        ),
        Section(
          title: 'Section 2',
          text: 'This is section 2 of chapter 2.',
          image: 'assets/images/chapter2_section2.jpg',
        ),
      ],
    ),
  ];
  List<int> _completedSections = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chapters[_currentIndex].title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _chapters[_currentIndex]
              .sections!
              .asMap()
              .entries
              .map((MapEntry<int, Section> section) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Card(
                elevation: 8.0,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      section.value.image!,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      section.value.title!,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        section.value.text!,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    _completedSections.contains(section.key)
                        ? Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : RaisedButton(
                            child: Text('Mark as completed'),
                            onPressed: () {
                              setState(() {
                                _completedSections.add(section.key);
                              });
                            },
                          ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _chapters
            .map(
              (Chapter chapter) => BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: chapter.title,
              ),
            )
            .toList(),
      ),
    );
  }
}

class Chapter {
  String? title;
  List<Section>? sections;

  Chapter({this.title, this.sections});
}

class Section {
  String? title;
  String? text;
  String? image;

  Section({this.title, this.text, this.image});
}
