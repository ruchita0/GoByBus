import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location_track/NotificationsAdminPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../EditProfileAdmin.dart';
//import '../NotificationsAdminPage.dart';
import '../about_us.dart';
import '../busdeatilsadmin.dart';
import '../screens/login_screen.dart';

class HomePage extends StatefulWidget {
  final String userEmail; // Add userEmail as a parameter
  const HomePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LoginRequired(
      userEmail: widget.userEmail,
      child: Scaffold(
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
                launch(
                    'https://www.instagram.com/nkocet?igsh=eHdoZWc5MXYyZ280');
              },
              icon: const Icon(FontAwesomeIcons.instagram),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height *
                  0.75, // 35% of the screen height
              width: MediaQuery.of(context).size.width * 1,
              child: Image.asset(
                'images/HomePageImage.png', // Replace 'your_image_asset_path.jpg' with your image asset path
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   // MaterialPageRoute(
                  //   //   builder: (context) => NotificationsAdminPage(),
                  //   // ),
                  // );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/notify.png',
                      width: 50,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Click here to Notify Students',
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
              Container(
                color: Colors.blue, // Add blue color here
                child: MyHeaderDrawer(
                  userEmail: widget.userEmail,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.directions_bus),
                title: const Text(
                  'Bus Details',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BusDetailsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsAdminPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 20,
                  ),
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
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                /// The above Dart code is handling an onTap event, which triggers the sign-out process using the `_authService.signOut()` method. After signing out, it navigates to the `LoginScreen` by replacing the current route using `Navigator.pushReplacement`.
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditProfileAdmin(userEmail: widget.userEmail)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHeaderDrawer extends StatefulWidget {
  final String userEmail; // Add userEmail as a parameter
  const MyHeaderDrawer({Key? key, required this.userEmail}) : super(key: key);

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  late Stream<DocumentSnapshot> _userStream;
  String username = '';

  @override
  void initState() {
    super.initState();
    _userStream = FirebaseFirestore.instance
        .collection('AdminLogin')
        .where('Username',
            isEqualTo: widget
                .userEmail) // Assuming widget.userEmail holds the email of the current user
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        throw Exception('User document not found');
      }
    });

    // Fetch additional data from 'UserLogin' collection
    fetchAdditionalData();
  }

  void fetchAdditionalData() {
    _userStream.listen((userDoc) {
      setState(() {
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
            const Text(
              "Admin",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 5),
            Text(
              username,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginRequired extends StatelessWidget {
  final String userEmail;
  final Widget child;

  const LoginRequired({Key? key, required this.userEmail, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userEmail.isEmpty) {
      return LoginScreen(
        onLogin: (email) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => child),
          );
        },
      );
    }
    return child;
  }
}

enum DrawerSections {
  firstpage,
}
