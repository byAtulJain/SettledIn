import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'detail_service_page.dart';
import 'user_profile.dart';

class Saved extends StatelessWidget {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bookmarks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('bookmarks')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading bookmarks'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No bookmarks found'));
                  }

                  List<DocumentSnapshot> bookmarks = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      var bookmark = bookmarks[index];
                      String serviceId = bookmark['serviceId'];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('services')
                            .doc(serviceId)
                            .get(),
                        builder: (context, serviceSnapshot) {
                          if (serviceSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(); // Don't show anything while loading
                          } else if (serviceSnapshot.hasError) {
                            return Container(); // Don't show any error message
                          } else if (!serviceSnapshot.hasData ||
                              !serviceSnapshot.data!.exists) {
                            // If the service has been deleted, automatically remove the bookmark
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('bookmarks')
                                .doc(serviceId)
                                .delete();
                            return Container(); // Don't show anything if the service is deleted
                          }

                          var serviceData = serviceSnapshot.data!;
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                _createRouteForDetail(serviceId, serviceData),
                              );
                            },
                            child: _buildServiceBox(
                              image: serviceData['images'][0],
                              name: serviceData['name'],
                              price: serviceData['price'],
                              address: serviceData['address'],
                              tags: serviceData['tags'],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  // Create route with animation for detail page
  Route _createRouteForDetail(String serviceId, DocumentSnapshot serviceData) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ServiceDetailPage(
        serviceId: serviceId,
        images: List<String>.from(serviceData['images']),
        name: serviceData['name'],
        price: serviceData['price'],
        tags: serviceData['tags'],
        description: serviceData['description'],
        address: serviceData['address'],
        openingTime: serviceData['openingTime'],
        closingTime: serviceData['closingTime'],
        location: LatLng(
          serviceData['location'].latitude,
          serviceData['location'].longitude,
        ),
        phoneNumber: serviceData['phoneNumber'],
        whatsappNumber: serviceData['whatsappNumber'],
      ),
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
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  Widget _buildServiceBox({
    required String image,
    required String name,
    required int price,
    required String address,
    required String tags,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  'Rs. $price${tags.toLowerCase() == 'laundries' ? '/load' : '/month'}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  address,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
