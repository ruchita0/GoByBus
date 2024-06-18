import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'location.dart';

class bus extends StatefulWidget {
  const bus({super.key});

  @override
  State<bus> createState() => _bus();
}

//  onPressed: (() {
//               Navigator.push(context,MaterialPageRoute(builder: ((context) => secondscreen())))
//               //Get.to(secondscreen());
//             }),

class _bus extends State<bus> {
  bool showImage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Where is my Bus!!?'),
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             SizedBox(
//               //Use of SizedBox
//               height: 40,
//             ),
//             Center(
//               child: SizedBox(
//                 width: 500.0,
//                 height: 100.0,
//                 child: ElevatedButton.icon(
//                   icon: const Icon(
//                     Icons.bus_alert_rounded,
//                     size: 50.0,
//                   ),
//                   label: Center(
//                     child: const Text("ALL BUSES LOCATION \n   INFORMATION",
//                         style: TextStyle(
//                             fontSize: 20.0,
//                             //color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             decoration: TextDecoration.underline)),
//                   ),
//                   onPressed: () => (Text("pressed")),
//                   style:
//                       ElevatedButton.styleFrom(primary: Colors.purple.shade100),
//                 ),
//               ),
//             ),
//             SizedBox(
//               //Use of SizedBox
//               height: 40,
//             ),
//             SizedBox(
//               width: 500.0,
//               height: 60.0,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.bus_alert_rounded),
//                 label: const Text("BUS 1 LOCATION"),
//                 onPressed: () => (Navigator.pushNamed(context,'locationtrack'))),
//               ),
//             ),
//             SizedBox(
//               //Use of SizedBox
//               height: 30,
//             ),
//             SizedBox(
//               width: 500.0,
//               height: 60.0,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.bus_alert_rounded),
//                 label: const Text("BUS 2 LOCATION"),
//                 onPressed: () => (Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Locationtrack(),
//                     ))),
//               ),
//             ),
//             SizedBox(
//               //Use of SizedBox
//               height: 30,
//             ),
//             SizedBox(
//               width: 500.0,
//               height: 60.0,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.bus_alert_rounded),
//                 label: const Text("BUS 3 LOCATION"),
//                 onPressed: () => (Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Locationtrack(),
//                     ))),
//               ),
//             ),
//             SizedBox(
//               //Use of SizedBox
//               height: 30,
//             ),
//             SizedBox(
//               width: 500.0,
//               height: 60.0,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.bus_alert_rounded),
//                 label: const Text("BUS 4 LOCATION"),
//                 onPressed: () => (Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Locationtrack(),
//                     ))),
//               ),
//             ),
//             SizedBox(
//               //Use of SizedBox
//               height: 30,
//             ),
//              SizedBox(
//               width: 500.0,
//               height: 60.0,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.bus_alert_rounded),
//                 label: const Text("BUS 5 LOCATION"),
//                 onPressed: () => ("bus statiupn"),
//               ),
//             ), // This trailing comma makes auto-formatting nicer for build methods.
//           ],
//         );
//         );
//   }
// }
          children: [
            SizedBox(
              //Use of SizedBox
              height: 40,
            ),

            Center(
              child: SizedBox(
                width: 500.0,
                height: 100.0,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.bus_alert_rounded,
                    size: 60.0,
                  ),
                  label: const Text("ALL BUSES LOCATION INFORMATION",
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
            SizedBox(
              //Use of SizedBox
              height: 50,
            ),
            SizedBox(
              width: 500.0,
              height: 60.0,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bus_alert_rounded),
                label: const Text("BUS 1 LOCATION"),
                onPressed: () => (Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => location1(n: '1'))))),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100),
              ),
            ),
            SizedBox(
              //Use of SizedBox
              height: 30,
            ),
            SizedBox(
              width: 500.0,
              height: 60.0,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bus_alert_rounded),
                label: const Text("BUS 2 LOCATION"),
                onPressed: () => (Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => location1(n: '2'))))),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100),
              ),
            ),
            SizedBox(
              //Use of SizedBox
              height: 30,
            ),

            SizedBox(
              width: 500.0,
              height: 60.0,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bus_alert_rounded),
                label: const Text("BUS 3 LOCATION"),
                onPressed: () => (Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => location1(n: '3'))))),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100),
              ),
            ),
            SizedBox(
              //Use of SizedBox
              height: 30,
            ),

            SizedBox(
              width: 500.0,
              height: 60.0,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bus_alert_rounded),
                label: const Text("BUS 4 LOCATION"),
                onPressed: () => (Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => location1(n: '4'))))),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100),
              ),
            ),
            SizedBox(
              //Use of SizedBox
              height: 30,
            ),

            SizedBox(
              width: 500.0,
              height: 60.0,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bus_alert_rounded),
                label: const Text("BUS 5 LOCATION"),
                onPressed: () => (Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => location1(n: '5'))))),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ],
        ));
  }
}
