import 'package:flutter/material.dart';
import 'package:location_track/contactdetails.dart';
import 'package:location_track/fees_receipts_admin.dart';

class BusDetailsPage extends StatelessWidget {
  const BusDetailsPage({Key? key}) : super(key: key);

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
                        builder: (context) => const FeesReceiptAdmin()),
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
                    MaterialPageRoute(
                        builder: (context) => const AdminScreen()),
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
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
