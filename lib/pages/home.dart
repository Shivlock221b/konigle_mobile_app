import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/utility/horizontally_scrollable_bottom_nav.dart';
import 'package:photo_view/photo_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_chapters[_currentIndex].title!),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: LinearProgressIndicator(
            value: _progressValue, // set progress value
            backgroundColor: Colors.green, // set background color
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black), // set progress color
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
                    // Image.asset(
                    //   section.value.image!,
                    //   fit: BoxFit.cover,
                    // ),
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