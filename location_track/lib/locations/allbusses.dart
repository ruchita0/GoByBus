import 'package:flutter/material.dart';
import 'package:location_track/locations/routedisplay.dart'; // Assuming this is the correct import path
import 'package:location_track/locations/bus_stud1.dart';

class allbusses extends StatefulWidget {
  const allbusses({super.key});

  @override
  State<allbusses> createState() => _allbusses();
}

class _allbusses extends State<allbusses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Bus Track"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: SizedBox(
              width: 370.0,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bus_alert_rounded,
                    size: 30.0,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "All Busses Information",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: buildCard(
                    context: context,
                    title: 'Bus 1',
                    BusButton: 1,
                    subtitle: 'MIDC...NKOCET',
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: buildCard(
                    context: context,
                    title: 'Bus 2',
                    BusButton: 2,
                    subtitle: 'Neharu...NKOCET',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: buildCard(
                    context: context,
                    title: 'Bus 3',
                    BusButton: 3,
                    subtitle: 'DMart...NKOCET',
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: buildCard(
                    context: context,
                    title: 'Bus 4',
                    BusButton: 4,
                    subtitle: 'Saat Rasta...NKOCET',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  Card buildCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int BusButton,
  }) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: Colors.blue,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bus_alert,
                color: Colors.blue.shade900,
              ),
              ListTile(
                title: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Routedisplay(n: BusButton),
                    ),
                  );
                },
                child: const Text(
                  'Route',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
                onPressed: () {
                  print("location btn clicked");
                  String ln = BusButton.toString();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => bus_stud(locationId: ln),
                    ),
                  );
                },
                child: const Text(
                  'Track',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
