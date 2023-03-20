import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/models/database.dart';
import 'package:konigle_mobile_app/models/userModel.dart';
import 'package:konigle_mobile_app/utility/horizontally_scrollable_bottom_nav.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/userProvider.dart';

/**
 * Home Page: The User FYP in the App.
 * Contains the chapter list which could be made dynamic.
 * The chapter class is a helper class to maintain the chapter within each chapter.
 */
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  double _progressValue = 0.5;
  bool loading = true;
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

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
      User user = Database.getUserByIndex(value.getInt("index")!);
      provider.setCurrentUser(user);
      if (mounted) {
        setState(() {
          _currentIndex = value.getInt("chapter") ?? 0;
          loading = false;
        });
      }
    });
  }

  List<BottomNavigationBarItem> createBottomNavItems() {
    return _chapters.map((e) =>
      BottomNavigationBarItem(
        icon: Icon(Icons.book, color: Color.fromRGBO(238, 116, 30, 1)),
        label: e.title
    )).toList();
  }

  void _onNavBarItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    SharedPreferences.getInstance().then((value) {
      value.setInt("chapter", index);
    });
  }

  // Calculate complete progress of the user across chapters.
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

  // Mark each section of the current chapter as completed for the user.
  bool isCompleted(UserProvider provider, Section section) {
    print(provider.user);
    for (ChapterProgress elem in provider.user!.chapterProgress!) {
      if (elem.chapterId == _currentIndex) {
        if (elem.sectionProgress!.contains(section.title)) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    UserProvider provider = Provider.of<UserProvider>(context);
    calcProgress(provider);

    return loading ? Scaffold(body: Center(child: CircularProgressIndicator(),),) : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [IconButton(icon: Icon(Icons.logout, color: Colors.black,), onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove("isLogin");
          Navigator.popAndPushNamed(context, "/login");
        },)],
        title: Text("Konigle", style: TextStyle(color: Colors.black),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text('Progress: ${_progressValue * 100}%'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("0 %"),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            value: _progressValue,
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
                    isCompleted(provider, section.value)
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
                        provider.markSectionAsComplete(_currentIndex, section.value.title!);
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