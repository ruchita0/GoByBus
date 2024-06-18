import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location_track/NotificationsUserPage.dart';
import 'package:location_track/about_us.dart';
import 'package:location_track/busdetailsuser.dart';
import 'package:location_track/locations/allbusses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../EditProfilePage.dart';
//import '../NotificationsUserPage.dart';
import 'login_screen.dart';

class HomePageUser extends StatefulWidget {
  final String userEmail;
  const HomePageUser({Key? key, required this.userEmail}) : super(key: key);

  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  //var currentPage = DrawerSections.firstpage;

  Future<List<String>> fetchNotifications() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Notifications')
        .where('userEmail', isEqualTo: widget.userEmail)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.get('message') as String)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NKOCET'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              launch('https://www.orchidengg.ac.in/');
            },
            icon: const Icon(FontAwesomeIcons.google),
          ),
          IconButton(
            onPressed: () {
              launch('https://www.facebook.com/NKORCHIDENGG?mibextid=ZbWKwL');
            },
            icon: const Icon(FontAwesomeIcons.facebook),
          ),
          IconButton(
            onPressed: () {
              launch('https://www.instagram.com/nkocet?igsh=eHdoZWc5MXYyZ280');
            },
            icon: const Icon(FontAwesomeIcons.instagram),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width * 1,
            child: Image.asset(
              'images/HomePageImage.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => allbusses(),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/track.png',
                    width: 50,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Click here to Track Bus',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            MyHeaderDrawer(userEmail: widget.userEmail),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text(
                'Bus Track',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => allbusses()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text(
                'Bus Details',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BusDetailsPage(userEmail: widget.userEmail)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text(
                'Notifications',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                fetchNotifications().then((notifications) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationsUserPage(notifications: notifications),
                    ),
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text(
                'About Us',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text(
                'Log Out',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('email');
                await prefs.remove('role');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(onLogin: (email) {})),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditProfilePage(userEmail: widget.userEmail)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyHeaderDrawer extends StatefulWidget {
  final String userEmail;
  const MyHeaderDrawer({Key? key, required this.userEmail}) : super(key: key);

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  late Stream<DocumentSnapshot> _userStream;
  String firstName = '';
  String secondName = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    _userStream = FirebaseFirestore.instance
        .collection('UserLogin')
        .where('Username', isEqualTo: widget.userEmail)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        throw Exception('User document not found');
      }
    });

    fetchAdditionalData();
  }

  void fetchAdditionalData() {
    _userStream.listen((userDoc) {
      setState(() {
        firstName = userDoc.get('firstName') ?? '';
        secondName = userDoc.get('secondName') ?? '';
        username = userDoc.get('Username') ?? '';
      });
    }, onError: (error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('images/profile.jpg'),
                ),
              ),
            ),
            Center(
              child: Text(
                '$firstName $secondName',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                username,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
