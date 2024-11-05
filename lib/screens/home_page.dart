import 'package:flutter/material.dart';
import 'package:setteldin/screens/user_profile.dart';

import 'all_services.dart';

class HomePage extends StatelessWidget {
  final Function onBusRoutesTap; // Callback to navigate to Bus Routes
  final Function onHostelsTap; // Callback for Hostels
  final Function onFlatsTap; // Callback for Flats
  final Function onTiffinsTap; // Callback for Tiffins
  final Function onLaundryTap; // Callback for Laundry

  HomePage({
    required this.onBusRoutesTap,
    required this.onHostelsTap,
    required this.onFlatsTap,
    required this.onTiffinsTap,
    required this.onLaundryTap,
  });

  //for user profile
  Route _createRouteForProfile() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          UserProfilePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 300), // Same duration
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.grey.shade100,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              "Settled",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            Text(
              "In",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.black,
              size: 32,
            ),
            onPressed: () {
              Navigator.of(context).push(_createRouteForProfile());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find your needs',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          AllServices(
                        selectedCategoryIndex: 0,
                        focusSearchBar: true, // Focus the search bar
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var tween = Tween(begin: 0.0, end: 1.0)
                            .chain(CurveTween(curve: Curves.easeInOut));
                        return FadeTransition(
                            opacity: animation.drive(tween), child: child);
                      },
                      transitionDuration: Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // Welcome text with one smaller and one larger
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey, welcome back.',
                  style: TextStyle(
                    fontSize: 15, // Smaller font for the top text
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2), // Small gap between the two texts
                Text(
                  'Let\'s Settle again!',
                  style: TextStyle(
                    fontSize: 23, // Larger font for the bottom text
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Four block section similar to Swiggy
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () => onHostelsTap(),
                  child: _buildServiceBlock(
                    title: 'Hostels',
                    subtitle: 'Affordable stays nearby',
                    image: 'images/hostel.png',
                    backgroundColor: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => onFlatsTap(),
                  child: _buildServiceBlock(
                    title: 'Flats',
                    subtitle: 'Rent your dream space',
                    image: 'images/flats.png',
                    backgroundColor: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => onTiffinsTap(),
                  child: _buildServiceBlock(
                    title: 'Tiffins',
                    subtitle: 'Healthy meals delivered daily',
                    image: 'images/tiffins.png',
                    backgroundColor: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => onLaundryTap(),
                  child: _buildServiceBlock(
                    title: 'Laundry',
                    subtitle: 'Quick and clean service',
                    image: 'images/laundry.png',
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                onBusRoutesTap(); // Call the navigation function
              },
              child: _buildFullWidthServiceBlock(
                title: 'Bus Routes',
                subtitle: 'Explore convenient travel routes',
                image: 'images/bus_route.png',
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each block with image as background
  Widget _buildServiceBlock({
    required String title,
    required String subtitle,
    required String image,
    required Color backgroundColor,
  }) {
    return Container(
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Smooth shadow color
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3), // Shadow positioning
          ),
        ],
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.contain, // Makes sure the image covers the container
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text at the top
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black, // White text for visibility on image
            ),
          ),
          // SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.black, // Light text color for visibility
              fontSize: 14,
            ),
          ),
          Spacer(), // Pushes everything upwards
        ],
      ),
    );
  }

  // Helper method to build a full-width block with image as background
  Widget _buildFullWidthServiceBlock({
    required String title,
    required String subtitle,
    required String image,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      height: 150, // Same height as the smaller blocks
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Smooth shadow color
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3), // Shadow positioning
          ),
        ],
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fill, // Makes sure the image covers the container
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text at the top
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black, // White text for visibility on image
            ),
          ),
          // SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.black, // Light text color for visibility
              fontSize: 14,
            ),
          ),
          Spacer(), // Pushes everything upwards
        ],
      ),
    );
  }
}
