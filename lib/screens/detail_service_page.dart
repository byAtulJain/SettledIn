import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Add this import

class ServiceDetailPage extends StatefulWidget {
  final String serviceId; // Add serviceId
  final List<String> images;
  final String name;
  final int price;
  final String tags;
  final String description;
  final String address;
  final String openingTime;
  final String closingTime;
  final LatLng location;
  final String phoneNumber;
  final String whatsappNumber;

  ServiceDetailPage({
    required this.serviceId, // Add serviceId to the constructor
    required this.images,
    required this.name,
    required this.price,
    required this.tags,
    required this.description,
    required this.address,
    required this.openingTime,
    required this.closingTime,
    required this.location,
    required this.phoneNumber,
    required this.whatsappNumber,
  });

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  // Function to open phone dialer
  void _launchPhoneDialer(String phoneNumber) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (res == null || !res) {
      print('Could not place the call.');
    }
  }

  // Function to open WhatsApp chat
  void _launchWhatsApp(String whatsappNumber) async {
    final link = WhatsAppUnilink(
      phoneNumber: whatsappNumber,
      text: "Hello, I'm interested in your services.", // Predefined message
    );
    await launchUrl(Uri.parse('$link'));
  }

  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  void _checkIfBookmarked() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .doc(widget.serviceId) // Use serviceId here
          .get();
      setState(() {
        isBookmarked = doc.exists;
      });
    }
  }

  void _toggleBookmark() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference bookmarkRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .doc(widget.serviceId); // Use serviceId here

      if (isBookmarked) {
        await bookmarkRef.delete();
      } else {
        await bookmarkRef.set({
          'serviceId': widget.serviceId, // Store only the reference
          'timestamp': FieldValue.serverTimestamp(), // Optional timestamp
        });
      }

      setState(() {
        isBookmarked = !isBookmarked;
      });
    }
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
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.black,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display images in a carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: true,
                ),
                items: widget.images.map((image) {
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              // Display name
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Display price
              Text(
                "Rs. ${widget.price}${widget.tags.toLowerCase() == 'laundries' ? '/load' : '/month'}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 10),
              // Display tags
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.tags,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Description
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              // Address
              Text(
                'Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.address,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              // Timing
              Text(
                'Timing',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Opening Time: ${widget.openingTime}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Closing Time: ${widget.closingTime}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              // Location
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 200,
                decoration: BoxDecoration(
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
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.location,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('serviceLocation'),
                      position: widget.location,
                    ),
                  },
                ),
              ),
              SizedBox(height: 20),
              // Phone and WhatsApp buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _launchPhoneDialer(widget.phoneNumber);
                    },
                    icon: Icon(Icons.phone, color: Colors.white),
                    label: Text('Contact Us'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _launchWhatsApp(widget.whatsappNumber);
                    },
                    icon:
                        FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                    label: Text('WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
