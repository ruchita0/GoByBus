import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  final User? user = FirebaseAuth.instance.currentUser;
  String firstName = ''; // To store the user's first name
  String secondName = ''; // To store the user's second name
  String userEmail = ''; // To store the user's email

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // Call the method to fetch user info
  }

  Future<void> fetchUserInfo() async {
    if (user != null) {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      setState(() {
        firstName = userSnapshot.get('firstName');
        secondName = userSnapshot.get('secondName');
        userEmail = user!.email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          Text(
            '$firstName $secondName', // Display the fetched user's full name
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
          Text(
            userEmail, // Display the fetched user's email
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
