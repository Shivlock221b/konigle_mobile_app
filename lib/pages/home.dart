import 'package:flutter/material.dart';

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