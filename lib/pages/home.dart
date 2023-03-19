import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/models/database.dart';
import 'package:konigle_mobile_app/models/userModel.dart';
import 'package:konigle_mobile_app/utility/horizontally_scrollable_bottom_nav.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/userProvider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  double _progressValue = 0.5;
  List<Chapter> _chapters = [
    Chapter(
      title: 'Chapter 1',
      sections: [
        Section(
          title: 'Section 1',
          text: 'This is section 1 of chapter 1.',
          image: 'assets/images/section 1.jpg',
        ),
        Section(
          title: 'Section 2',
          text: 'This is section 2 of chapter 1.',
          image: 'assets/images/section 2.jpg',
        ),
      ],
    ),
    Chapter(
      title: 'Chapter 2',
      sections: [
        Section(
          title: 'Section 1',
          text: 'This is section 1 of chapter 2.',
          image: 'assets/images/section 1.jpg',
        ),
        Section(
          title: 'Section 2',
          text: 'This is section 2 of chapter 2.',
          image: 'assets/images/section 2.jpg',
        ),
      ],
    ),
    Chapter(
      title: 'Chapter 3',
      sections: [
        Section(
          title: 'Section 1',
          text: 'This is section 1 of chapter 3.',
          image: 'assets/images/section 1.jpg',
        ),
        Section(
          title: 'Section 2',
          text: 'This is section 2 of chapter 3.',
          image: 'assets/images/section 2.jpg',
        ),
      ],
    ),Chapter(
      title: 'Chapter 4',
      sections: [
        Section(
          title: 'Section 1',
          text: 'This is section 1 of chapter 4.',
          image: 'assets/images/section 1.jpg',
        ),
        Section(
          title: 'Section 2',
          text: 'This is section 2 of chapter 4.',
          image: 'assets/images/section 2.jpg',
        ),
      ],
    ),
  ];
  List<int> _completedSections = [];

  List<BottomNavigationBarItem> createBottomNavItems() {
    return _chapters.map((e) =>
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: e.title
    )).toList();
  }

  void _onNavBarItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void calcProgress(UserProvider provider) {
    User? user = provider.user;
    if (user == null) {
      print("User is null");
    } else {
      int completedSections = 0;
      for (ChapterProgress elem in user.chapterProgress!) {
        completedSections = completedSections + elem.sectionProgress!.length;
      }
      setState(() {
        _progressValue = completedSections / (_chapters.length * 2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    UserProvider provider = Provider.of<UserProvider>(context);
    calcProgress(provider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_chapters[_currentIndex].title!, style: TextStyle(color: Colors.black),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text('Progress: $_progressValue'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("0 %"),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            value: 0.7,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      ),
                      Text("100 %"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
                    SizedBox(
                      height: 200,
                        child: PhotoView(imageProvider: AssetImage(section.value.image!))),
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
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove("isLogin");
                        Database db = Database();
                        db.resetDb();
                        db.printDb();
                      },
                      child: Text('Clear prefs'),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: HorizontalScrollableBottomNavBar(
        items: createBottomNavItems(),
        onItemSelected: _onNavBarItemSelected,
        initialIndex: _currentIndex,
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