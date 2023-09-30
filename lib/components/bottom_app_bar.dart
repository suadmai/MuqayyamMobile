import 'package:flutter/material.dart';

import '../pages/homeScreen.dart';

class CustomBottomAppBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  CustomBottomAppBar({
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFF82618B), // Customize the background color
      shape: CircularNotchedRectangle(),
      notchMargin: 10.0,
      child: SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Replace with your desired icons and functionality
            IconButton(
              onPressed: () {
                onTabSelected(
                    0); // You can use a function to handle the tap event
              },
              icon: Icon(
                Icons.home,
                color: currentIndex == 0
                    ? Colors.white
                    : Colors
                        .grey, // Customize the color based on the selected index
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.search,
                color: currentIndex == 1 ? Colors.white : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                onTabSelected(2);
              },
              icon: Icon(
                Icons.emoji_events,
                color: currentIndex == 2 ? Colors.white : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                onTabSelected(3);
              },
              icon: Icon(
                Icons.settings,
                color: currentIndex == 3 ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
