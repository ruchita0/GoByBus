import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_model_list/dropdown_model_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location_track/upi_payments.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyAhVioZbRyKAUigZUNXxQgrQW-LCLCSxmI',
            appId: '1:531918336932:android:7075ff906815c03ff54731',
            messagingSenderId: '531918336932',
            projectId: 'location-c67b5',
          ),
        )
      : await Firebase.initializeApp();
  String userEmail = ""; // Leave userEmail blank

  runApp(MyApp(userEmail: userEmail));
}

class MyApp extends StatelessWidget {
  final String userEmail;

  const MyApp({Key? key, required this.userEmail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(userEmail: userEmail),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String userEmail;

  const MyHomePage({Key? key, required this.userEmail}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> savedRoutes = [];
  bool routeSaved = false;
  bool paymentDone = false;
  DropListModel dropListModel = DropListModel([
    OptionItem(id: "1", title: "MIDC Chowk - NKOCET"),
    OptionItem(id: "2", title: "Nehru Nagar - NKOCET"),
    OptionItem(id: "3", title: "DMart(Jule Solapur) - NKOCET"),
    OptionItem(id: "4", title: "Saat Rasta - NKOCET"),
  ]);
  OptionItem optionItemSelected = OptionItem(title: "Select your near by stop");
  String firstName = '';
  String secondName = '';
  String parentContactNumber = '';
  late Future<Map<String, dynamic>?> userData;

  @override
  void initState() {
    super.initState();
    userData = _getUserData();
    _loadPersistedData();
  }

  Future<void> _loadPersistedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? persistedTitle =
        prefs.getString('${widget.userEmail}_selected_route');
    bool? persistedRouteSaved =
        prefs.getBool('${widget.userEmail}_route_saved');
    bool? persistedPaymentDone =
        prefs.getBool('${widget.userEmail}_payment_done');
    List<String>? persistedRoutes =
        prefs.getStringList('${widget.userEmail}_saved_routes');

    if (persistedRoutes != null) {
      setState(() {
        savedRoutes = persistedRoutes.map((route) {
          final parts = route.split(',');
          return {
            'title': parts[0],
            'busNumber': parts[1],
            'fees': parts[2],
          };
        }).toList();
      });
    }

    if (persistedTitle != null) {
      setState(() {
        optionItemSelected = OptionItem(title: persistedTitle);
        routeSaved = persistedRouteSaved ?? false;
        paymentDone = persistedPaymentDone ?? false;
      });
    }
  }

  Future<void> _persistData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${widget.userEmail}_selected_route', optionItemSelected.title);
    await prefs.setBool('${widget.userEmail}_route_saved', routeSaved);
    await prefs.setBool('${widget.userEmail}_payment_done', paymentDone);
    List<String> routes = savedRoutes
        .map((route) =>
            '${route['title']},${route['busNumber']},${route['fees']}')
        .toList();
    await prefs.setStringList('${widget.userEmail}_saved_routes', routes);
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('UserLogin')
        .where('Username', isEqualTo: widget.userEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }
    return null;
  }

  void _onSaveRouteButtonPressed() {
    if (optionItemSelected.title != "Select your near by stop") {
      saveToFirestore();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a stop')),
      );
    }
  }

  void saveToFirestore() {
    if (optionItemSelected.title != "Select your near by stop") {
      final busDetails = getBusDetails(optionItemSelected.title);
      final busNumber = busDetails['busNumber'] ?? '';
      final fees = busDetails['fees'] ?? '';

      if (busNumber.isNotEmpty && fees.isNotEmpty) {
        FirebaseFirestore.instance.collection(busNumber).add({
          'title': optionItemSelected.title,
          'fees': fees,
          'ParentContactNumber': parentContactNumber,
          'Username': '$firstName $secondName',
          'Bus_no': busNumber,
        }).then((_) {
          setState(() {
            savedRoutes.insert(0, {
              'title': optionItemSelected.title,
              'busNumber': busNumber,
              'fees': fees,
            });
            routeSaved = true;
          });
          _persistData();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Route Saved Successfully!!')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid bus number or fees')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a stop')),
      );
    }
  }

  Map<String, String> getBusDetails(String stopTitle) {
    switch (stopTitle) {
      case 'MIDC Chowk - NKOCET':
        return {
          'busNumber': 'Bus 1',
          'fees': '6500/Sem',
        };
      case 'Nehru Nagar - NKOCET':
        return {
          'busNumber': 'Bus 2',
          'fees': '6000/Sem',
        };
      case 'DMart(Jule Solapur) - NKOCET':
        return {
          'busNumber': 'Bus 3',
          'fees': '6000/Sem',
        };
      case 'Saat Rasta - NKOCET':
        return {
          'busNumber': 'Bus 4',
          'fees': '6500/Sem',
        };
      default:
        return {
          'busNumber': '',
          'fees': 'Unknown',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Fees Structure'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('User data not found.'));
            } else {
              final userData = snapshot.data!;
              firstName = userData['firstName']?.toString() ?? '';
              secondName = userData['secondName']?.toString() ?? '';
              parentContactNumber =
                  userData['ParentContactNumber']?.toString() ?? '';

              return Column(
                children: <Widget>[
                  SelectDropList(
                    itemSelected: optionItemSelected,
                    dropListModel: dropListModel,
                    showIcon: true,
                    showArrowIcon: true,
                    showBorder: true,
                    paddingTop: 0,
                    icon: const Icon(Icons.location_on_outlined,
                        color: Colors.black),
                    onOptionSelected: (optionItem) {
                      setState(() {
                        optionItemSelected = optionItem;
                        routeSaved = false;
                        paymentDone = false;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  if (optionItemSelected.title != "Select your near by stop")
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                optionItemSelected.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Username: $firstName $secondName",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                "Bus no: ${getBusDetails(optionItemSelected.title)['busNumber']}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Fees: ${getBusDetails(optionItemSelected.title)['fees']}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text("Parent's Number: $parentContactNumber",
                                  style: const TextStyle(fontSize: 16)),
                              ElevatedButton(
                                onPressed: routeSaved
                                    ? null
                                    : _onSaveRouteButtonPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: routeSaved
                                      ? Colors.grey
                                      : Colors.blue.shade900,
                                ),
                                child: Text(
                                  routeSaved
                                      ? 'Route Saved Successfully'
                                      : 'Save the Route',
                                ),
                              ),
                              if (routeSaved)
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: paymentDone
                                          ? null
                                          : () async {
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpiPayment(
                                                    selectedItem:
                                                        optionItemSelected,
                                                    userEmail: widget.userEmail,
                                                  ),
                                                ),
                                              );
                                              if (result == true) {
                                                setState(() {
                                                  paymentDone = true;
                                                });
                                                _persistData();
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade900,
                                      ),
                                      child: const Text(
                                          'Make Payment via Razor Pay'),
                                    ),
                                    if (paymentDone)
                                      const Text('Payment is Done',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16)),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: savedRoutes.length,
                      itemBuilder: (context, index) {
                        final route = savedRoutes[index];
                        return Card(
                          child: ListTile(
                            title: Text(route['title'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bus no: ${route['busNumber'] ?? ''}"),
                                Text("Fees: ${route['fees'] ?? ''}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
