import 'package:flutter/material.dart';
import 'package:location_track/contactdetails.dart';
import 'package:location_track/feesreceiptuploaduser.dart';
import 'MyHomePage.dart';

class BusDetailsPage extends StatelessWidget {
  final String userEmail; // Add userEmail as a parameter
  const BusDetailsPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Details'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 8, // Added elevation for shadow
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(userEmail: userEmail),
                    ),
                  );
                },
                child: Container(
                  height: 150,
                  width: 150,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.library_books_rounded,
                          size: 50, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        'Bus Fees Structure',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 8, // Added elevation for shadow
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FeesReceiptUpload(userEmail: userEmail),
                    ),
                  );
                },
                child: Container(
                  height: 150,
                  width: 150,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.receipt_long_rounded,
                          size: 50, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        'Fees Receipt',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 8, // Added elevation for shadow
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserScreen()),
                  );
                },
                child: Container(
                  height: 150,
                  width: 150,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.contact_phone_rounded,
                          size: 50, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        'Contact Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
