import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_track/locations/mymap.dart';

class bus_stud extends StatefulWidget {
  final String locationId;

  const bus_stud({Key? key, required this.locationId}) : super(key: key);

  @override
  State<bus_stud> createState() => _bus_studState(locationId: locationId);
}

class _bus_studState extends State<bus_stud> {
  final String locationId;

  _bus_studState({required this.locationId});

  @override
  void initState() {
    super.initState();
    // Navigate directly when the widget is initialized
    directLocation();
  }

  void directLocation() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('location$locationId')
          .get();
      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyMap(docId, locationId),
          ),
        );
      } else {
        // Handle case when there is no data
        print('No data available');
      }
    } catch (error) {
      // Handle errors
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return an empty container since the navigation is done in initState
    return Container();
  }
}
