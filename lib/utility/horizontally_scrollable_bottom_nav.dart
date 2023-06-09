import 'package:flutter/material.dart';

/**
 * A customised class to create horizontally scrollable Bottom Nav
 * using the BottomNavItems.
 * Used to for dynamic chapter lists
 */

class HorizontalScrollableBottomNavBar extends StatefulWidget {
  final List<BottomNavigationBarItem> items;
  final Function(int index) onItemSelected;
  final int initialIndex;

  const HorizontalScrollableBottomNavBar({
    Key? key,
    required this.items,
    required this.onItemSelected,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _HorizontalScrollableBottomNavBarState createState() =>
      _HorizontalScrollableBottomNavBarState();
}

class _HorizontalScrollableBottomNavBarState
    extends State<HorizontalScrollableBottomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 80.0,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
                widget.onItemSelected(_currentIndex);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? Colors.blue[100]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.items[index].icon,
                    SizedBox(height: 10,),
                    Text(widget.items[index].label!)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
