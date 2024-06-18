import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_track/locations/mymap.dart';

class bus_stud extends StatefulWidget {
  const bus_stud({super.key});

  @override
  State<bus_stud> createState() => _bus_stud();
}

class _bus_stud extends State<bus_stud> {
  bool showImage = true;
  String? l = '1';
  void directlocation(String lk) {
    print("inside000");
    StreamBuilder(
      stream: FirebaseFirestore.instance.collection('location$lk').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return MyMap(snapshot.data!.docs[index].id, l);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Where is my Bus?'),
        ),
        body: Column(
          children: [
            const SizedBox(
              //Use of SizedBox
              height: 50,
            ),
            Expanded(
              flex: 0,
              child: Center(
                child: SizedBox(
                  width: 500.0,
                  height: 100.0,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.bus_alert_rounded,
                      size: 60.0,
                    ),
                    label: const Text("ALL BUSES LOCATION \n INFORMATION",
                        style: TextStyle(
                            fontSize: 20.0,
                            //color: Color.fromARGB(255, 163, 80, 174),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline)),
                    onPressed: () => (print("bus")),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade100),
                  ),
                ),
              ),
            ),
            const SizedBox(
              //Use of SizedBox
              height: 50,
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                width: 500.0,
                //height: 60.0,
                child: Expanded(
                    child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('location$l')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                width: 350.0,
                                height: 60.0,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.bus_alert_rounded),
                                  label: const Text("BUS 1"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => MyMap(
                                                snapshot.data!.docs[index].id,
                                                l))));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple.shade100),
                                ),
                              ),
                              const SizedBox(
                                //Use of SizedBox
                                height: 30,
                              ),
                              SizedBox(
                                width: 350.0,
                                height: 60.0,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.bus_alert_rounded),
                                  label: const Text("BUS 2"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => MyMap(
                                                snapshot.data!.docs[index].id,
                                                '2'))));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple.shade100),
                                ),
                              ),
                              const SizedBox(
                                //Use of SizedBox
                                height: 30,
                              ),
                              SizedBox(
                                width: 350.0,
                                height: 60.0,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.bus_alert_rounded),
                                  label: const Text("BUS 3"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => MyMap(
                                                snapshot.data!.docs[index].id,
                                                '3'))));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple.shade100),
                                ),
                              ),
                              const SizedBox(
                                //Use of SizedBox
                                height: 30,
                              ),
                              SizedBox(
                                width: 350.0,
                                height: 60.0,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.bus_alert_rounded),
                                  label: const Text("BUS 4"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => MyMap(
                                                snapshot.data!.docs[index].id,
                                                '4'))));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple.shade100),
                                ),
                              ),
                              const SizedBox(
                                //Use of SizedBox
                                height: 30,
                              ),
                            ],
                          );
                        });
                  },
                )),
              ),
            ),
          ],
        ));
  }
}
