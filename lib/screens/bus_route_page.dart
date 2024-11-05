import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:setteldin/screens/user_profile.dart';

class BusRoutesPage extends StatefulWidget {
  @override
  _BusRoutesPageState createState() => _BusRoutesPageState();
}

// For user profile
Route _createRouteForProfile() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => UserProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var fadeAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: fadeAnimation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 300), // Same duration
  );
}

class _BusRoutesPageState extends State<BusRoutesPage> {
  late GoogleMapController mapController;

  // Initial location of Indore
  final LatLng _indoreCenter = LatLng(22.7196, 75.8577);

  // Define polylines for bus routes
  final Set<Polyline> _busRoutes = {
    // Route 1: From Rajwada to Palasia
    Polyline(
      polylineId: PolylineId("route1"),
      points: [
        LatLng(22.7196, 75.8577), // Rajwada
        LatLng(22.7221, 75.8592), // Near Chhoti Gwaltoli
        LatLng(22.7274, 75.8650), // Geeta Bhawan Square
        LatLng(22.7313, 75.8712), // Palasia Square
      ],
      color: Colors.red,
      width: 4,
    ),
    // Route 2: From Vijay Nagar to Radisson Square
    Polyline(
      polylineId: PolylineId("route2"),
      points: [
        LatLng(22.7506, 75.8939), // Vijay Nagar Square
        LatLng(22.7451, 75.8851), // Meghdoot Garden
        LatLng(22.7413, 75.8803), // Bombay Hospital
        LatLng(22.7373, 75.8755), // Radisson Square
      ],
      color: Colors.red,
      width: 4,
    ),
    // Route 3: From Bhawarkuan to Khajrana
    Polyline(
      polylineId: PolylineId("route3"),
      points: [
        LatLng(22.6929, 75.8590), // Bhawarkuan Square
        LatLng(22.6994, 75.8635), // Near Holkar Science College
        LatLng(22.7065, 75.8681), // Near Saket Square
        LatLng(22.7179, 75.8701), // Khajrana Temple
      ],
      color: Colors.red,
      width: 4,
    ),
    // Route 4: From Bhanwarkuan to Palasia
    Polyline(
      polylineId: PolylineId("route4"),
      points: [
        LatLng(22.6929, 75.8590), // Bhanwarkuan
        LatLng(22.6981, 75.8635), // Near Holkar College
        LatLng(22.7105, 75.8687), // Near TI Mall
        LatLng(22.7201, 75.8691), // Palasia
      ],
      color: Colors.red,
      width: 4,
    ),
    // Route 5: From Malwa Mill to Vijay Nagar
    Polyline(
      polylineId: PolylineId("route5"),
      points: [
        LatLng(22.7285, 75.8423), // Malwa Mill
        LatLng(22.7329, 75.8487), // Near Sarwate Bus Stand
        LatLng(22.7417, 75.8582), // Near Palasia Square
        LatLng(22.7506, 75.8939), // Vijay Nagar
      ],
      color: Colors.red,
      width: 4,
    ),
    // Route 6: From Dewas Naka to Airport
    Polyline(
      polylineId: PolylineId("route6"),
      points: [
        LatLng(22.7537, 75.9049), // Dewas Naka
        LatLng(22.7412, 75.8783), // Near MR10 Flyover
        LatLng(22.7235, 75.8695), // LIG Square
        LatLng(22.7133, 75.8159), // Indore Airport
      ],
      color: Colors.red,
      width: 4,
    ),
    // Route 7: From Palasia to Chhoti Gwaltoli
    Polyline(
      polylineId: PolylineId("route7"),
      points: [
        LatLng(22.7313, 75.8712), // Palasia
        LatLng(22.7280, 75.8656), // Near Industry House
        LatLng(22.7221, 75.8592), // Chhoti Gwaltoli
        LatLng(22.7196, 75.8577), // Rajwada
      ],
      color: Colors.red,
      width: 4,
    ),
    // Route 8: From Regal Square to Rajendra Nagar
    Polyline(
      polylineId: PolylineId("route8"),
      points: [
        LatLng(22.7175, 75.8544), // Regal Square
        LatLng(22.7045, 75.8535), // Near GPO
        LatLng(22.6938, 75.8501), // Near Bengali Square
        LatLng(22.6792, 75.8473), // Rajendra Nagar
      ],
      color: Colors.red,
      width: 4,
    ),
    // Route 9: From Rajwada to Musakhedi
    Polyline(
      polylineId: PolylineId("route9"),
      points: [
        LatLng(22.7196, 75.8577), // Rajwada
        LatLng(22.7261, 75.8614), // YN Road
        LatLng(22.7335, 75.8659), // Musakhedi
      ],
      color: Colors.red,
      width: 4,
    ),
    // Route 10: From Kesar Bagh to Rau
    Polyline(
      polylineId: PolylineId("route10"),
      points: [
        LatLng(22.7163, 75.8486), // Kesar Bagh Road
        LatLng(22.7056, 75.8352), // Near Raj Mohalla
        LatLng(22.6918, 75.8201), // Near Rau Circle
      ],
      color: Colors.red,
      width: 4,
    ),
  };

  // Define markers for bus routes
  final Set<Marker> _markers = {
    // Markers for Route 1: Rajwada to Palasia
    Marker(
      markerId: MarkerId('fromRajwada'),
      position: LatLng(22.7196, 75.8577), // Rajwada
      infoWindow: InfoWindow(title: "From: Rajwada"),
    ),
    Marker(
      markerId: MarkerId('toPalasia'),
      position: LatLng(22.7313, 75.8712), // Palasia Square
      infoWindow: InfoWindow(title: "To: Palasia"),
    ),

    // Route 2: Vijay Nagar to Radisson Square
    Marker(
      markerId: MarkerId('fromVijayNagar'),
      position: LatLng(22.7506, 75.8939), // Vijay Nagar Square
      infoWindow: InfoWindow(title: "From: Vijay Nagar"),
    ),
    Marker(
      markerId: MarkerId('toRadisson'),
      position: LatLng(22.7373, 75.8755), // Radisson Square
      infoWindow: InfoWindow(title: "To: Radisson Square"),
    ),

    // Route 3: Bhawarkuan to Khajrana
    Marker(
      markerId: MarkerId('fromBhawarkuan'),
      position: LatLng(22.6929, 75.8590), // Bhawarkuan Square
      infoWindow: InfoWindow(title: "From: Bhawarkuan"),
    ),
    Marker(
      markerId: MarkerId('toKhajrana'),
      position: LatLng(22.7179, 75.8701), // Khajrana Temple
      infoWindow: InfoWindow(title: "To: Khajrana"),
    ),

    // Route 4: Bhanwarkuan to Palasia
    Marker(
      markerId: MarkerId('fromBhanwarkuan'),
      position: LatLng(22.6929, 75.8590), // Bhanwarkuan
      infoWindow: InfoWindow(title: "From: Bhanwarkuan"),
    ),
    Marker(
      markerId: MarkerId('toPalasia2'),
      position: LatLng(22.7201, 75.8691), // Palasia
      infoWindow: InfoWindow(title: "To: Palasia"),
    ),

    // Route 5: Malwa Mill to Vijay Nagar
    Marker(
      markerId: MarkerId('fromMalwaMill'),
      position: LatLng(22.7285, 75.8423), // Malwa Mill
      infoWindow: InfoWindow(title: "From: Malwa Mill"),
    ),
    Marker(
      markerId: MarkerId('toVijayNagar'),
      position: LatLng(22.7506, 75.8939), // Vijay Nagar
      infoWindow: InfoWindow(title: "To: Vijay Nagar"),
    ),

    // Route 6: Dewas Naka to Airport
    Marker(
      markerId: MarkerId('fromDewasNaka'),
      position: LatLng(22.7537, 75.9049), // Dewas Naka
      infoWindow: InfoWindow(title: "From: Dewas Naka"),
    ),
    Marker(
      markerId: MarkerId('toAirport'),
      position: LatLng(22.7133, 75.8159), // Indore Airport
      infoWindow: InfoWindow(title: "To: Indore Airport"),
    ),

    // Route 7: Palasia to Chhoti Gwaltoli
    Marker(
      markerId: MarkerId('fromPalasia3'),
      position: LatLng(22.7313, 75.8712), // Palasia
      infoWindow: InfoWindow(title: "From: Palasia"),
    ),
    Marker(
      markerId: MarkerId('toChhotiGwaltoli'),
      position: LatLng(22.7221, 75.8592), // Chhoti Gwaltoli
      infoWindow: InfoWindow(title: "To: Chhoti Gwaltoli"),
    ),

    // Route 8: Regal Square to Rajendra Nagar
    Marker(
      markerId: MarkerId('fromRegalSquare'),
      position: LatLng(22.7175, 75.8544), // Regal Square
      infoWindow: InfoWindow(title: "From: Regal Square"),
    ),
    Marker(
      markerId: MarkerId('toRajendraNagar'),
      position: LatLng(22.6792, 75.8473), // Rajendra Nagar
      infoWindow: InfoWindow(title: "To: Rajendra Nagar"),
    ),

    // Route 9: Rajwada to Musakhedi
    Marker(
      markerId: MarkerId('fromRajwada2'),
      position: LatLng(22.7196, 75.8577), // Rajwada
      infoWindow: InfoWindow(title: "From: Rajwada"),
    ),
    Marker(
      markerId: MarkerId('toMusakhedi'),
      position: LatLng(22.7335, 75.8659), // Musakhedi
      infoWindow: InfoWindow(title: "To: Musakhedi"),
    ),

    // Route 10: Kesar Bagh to Rau
    Marker(
      markerId: MarkerId('fromKesarBagh'),
      position: LatLng(22.7163, 75.8486), // Kesar Bagh
      infoWindow: InfoWindow(title: "From: Kesar Bagh"),
    ),
    Marker(
      markerId: MarkerId('toRau'),
      position: LatLng(22.6918, 75.8201), // Rau Circle
      infoWindow: InfoWindow(title: "To: Rau"),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _indoreCenter,
          zoom: 13.0,
        ),
        polylines: _busRoutes, // Add bus routes as polylines
        markers: _markers, // Add markers to display "From" and "To"
        zoomControlsEnabled: false,
      ),
    );
  }
}
