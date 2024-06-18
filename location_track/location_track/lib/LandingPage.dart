import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_track/screens/login_screen.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    // Navigate to another screen after 5 seconds
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            // Pass a non-constant parameter
            onLogin: (email) {
              // Do something with the email address of the logged-in user
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/whiteBackground.jpg', // Replace with your background image asset
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SlideTransition(
                position: _animation,
                child: Image.asset(
                  'images/bus_landing.png', // Replace with your animation image asset
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              const LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'images/LandingPageText.png', // Replace with your welcome image asset
                width: 200,
                height: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
