import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import '../screens/home_page.dart';
import '../screens/saved.dart';
import '../screens/all_services.dart';
import '../screens/bus_route_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  int _selectedCategoryIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Initialize the pages list
    _pages = [
      HomePage(
        onBusRoutesTap: () => _onItemTapped(3),
        onHostelsTap: () => _updateCategoryAndNavigate(1),
        onFlatsTap: () => _updateCategoryAndNavigate(2),
        onTiffinsTap: () => _updateCategoryAndNavigate(3),
        onLaundryTap: () => _updateCategoryAndNavigate(4),
      ),
      AllServices(
        selectedCategoryIndex: _selectedCategoryIndex,
      ),
      Saved(),
      BusRoutesPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Change the index to navigate
    });
  }

  void _updateCategoryAndNavigate(int categoryIndex) {
    setState(() {
      _selectedCategoryIndex = categoryIndex;
      _currentIndex = 1; // Navigate to All Services page
      _pages[1] = AllServices(
          selectedCategoryIndex:
              _selectedCategoryIndex); // Update the All Services page with the new category
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_currentIndex],
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        color: Colors.white,
        backgroundColor: Colors.grey.shade100,
        animationDuration: Duration(milliseconds: 300),
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home_outlined,
              color: _currentIndex == 0 ? Colors.red : Colors.black,
            ),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.category_outlined,
              color: _currentIndex == 1 ? Colors.red : Colors.black,
            ),
            label: 'All Services',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.bookmark_border_outlined,
              color: _currentIndex == 2 ? Colors.red : Colors.black,
            ),
            label: 'Saved',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.bus_alert_outlined,
              color: _currentIndex == 3 ? Colors.red : Colors.black,
            ),
            label: 'Bus Routes',
          ),
        ],
        buttonBackgroundColor: Colors.white,
        onTap: _onItemTapped,
        height: 75,
      ),
    );
  }
}
