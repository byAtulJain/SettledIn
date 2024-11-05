import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:setteldin/widgets/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleLoginScreen extends StatefulWidget {
  @override
  _GoogleLoginScreenState createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _errorMessage = ''; // Variable to hold error message

  Future<void> _handleSignIn() async {
    try {
      // Force the Google Sign-In to show the account picker every time
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Check if email already exists in "merchants" collection
          QuerySnapshot merchantQuery = await _firestore
              .collection('merchants')
              .where('email', isEqualTo: user.email)
              .get();

          if (merchantQuery.docs.isNotEmpty) {
            // Email already exists in "merchants" collection
            setState(() {
              _errorMessage =
                  'This account already exists in SettledIn Merchant app.';
            });
            await _auth.signOut(); // Sign out the user
            return;
          }

          // Save login state
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          // Check if user already exists in "users" collection
          DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(user.uid).get();
          if (!userDoc.exists) {
            // Add user data to "users" collection
            await _firestore.collection('users').doc(user.uid).set({
              'name': user.displayName,
              'email': user.email,
            });
          }

          // Navigate to HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBar()),
          );
        } else {
          // If login fails, display error message
          setState(() {
            _errorMessage = 'Login failed. Please try again.';
          });
        }
      } else {
        // If login fails, display error message
        setState(() {
          _errorMessage = 'Login failed. Please try again.';
        });
      }
    } catch (error) {
      // Catch and display any error that occurs during login
      setState(() {
        _errorMessage = 'An error occurred: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Login Image.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'From housing to meals, we’ve got you covered. Sign in to explore the best options for you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            ElevatedButton(
              onPressed: _handleSignIn,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.red,
                  ), // Optional: add border to match Google button style
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sign In with',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Image.asset(
                    'images/google_logo.png',
                    height: 40, // Adjust the height to fit inside the button
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Show error message if login fails
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
