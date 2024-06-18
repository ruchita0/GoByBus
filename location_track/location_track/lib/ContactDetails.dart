import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatelessWidget {
  const ContactDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contact Details'),
        ),
        body: const Contacts(),
      ),
    );
  }
}

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? const AdminScreen()
          : const UserScreen(),
    );
  }
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  List<Map<String, String>> driversList = [];

  void _addDriver(BuildContext context) {
    String name = _nameController.text.trim();
    String number = _numberController.text.trim();

    final RegExp namePattern = RegExp(r'^[a-zA-Z\s]+$');
    final RegExp numberPattern = RegExp(r'^\d{10}$');

    if (name.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter both Name and Mobile Number.'),
        ),
      );
    } else if (!namePattern.hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name should contain only characters and spaces.'),
        ),
      );
    } else if (!numberPattern.hasMatch(number)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mobile Number should contain exactly 10 digits.'),
        ),
      );
    } else {
      FirebaseFirestore.instance.collection('driverContacts').add({
        'driverName': name,
        'driverNumber': number,
      }).then((_) {
        setState(() {
          driversList.add({
            'driverName': name,
            'driverNumber': number,
          });
        });

        _nameController.clear();
        _numberController.clear();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Driver added successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Driver Name'),
            ),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => _addDriver(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Add Driver',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AdminViewListScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text(
                'Edit List',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: driversList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(driversList[index]['driverName']!),
                    subtitle: Text(driversList[index]['driverNumber']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminViewListScreen extends StatelessWidget {
  const AdminViewListScreen({Key? key}) : super(key: key);

  Future<void> deleteDriver(
      BuildContext context, String? documentId, String? driverName) async {
    driverName ??= "Unknown Driver";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete $driverName?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (documentId != null) {
                  FirebaseFirestore.instance
                      .collection('driverContacts')
                      .doc(documentId)
                      .delete()
                      .then((_) {
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    // print('Error deleting driver: $error');
                  });
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('driverContacts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var contact = snapshot.data?.docs[index].data();
              return ListTile(
                title: Text(contact?['driverName']),
                subtitle: Text(contact?['driverNumber']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditDriverScreen(
                              documentId: snapshot.data?.docs[index].id,
                              initialName: contact?['driverName'],
                              initialNumber: contact?['driverNumber'],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        String? documentId = snapshot.data?.docs[index].id;
                        String? driverName = contact?['driverName'];
                        deleteDriver(context, documentId, driverName);
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditDriverScreen extends StatefulWidget {
  final String? documentId;
  final String? initialName;
  final String? initialNumber;

  const EditDriverScreen({
    Key? key,
    this.documentId,
    this.initialName,
    this.initialNumber,
  }) : super(key: key);

  @override
  _EditDriverScreenState createState() => _EditDriverScreenState();
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _numberController.text = widget.initialNumber ?? '';
  }

  void _updateDriver(BuildContext context) {
    String newName = _nameController.text.trim();
    String newNumber = _numberController.text.trim();

    final RegExp namePattern = RegExp(r'^[a-zA-Z\s]+$');
    final RegExp numberPattern = RegExp(r'^\d{10}$');

    if (newName.isEmpty || !namePattern.hasMatch(newName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter a valid name containing only characters and spaces.'),
        ),
      );
      return;
    }

    if (newNumber.isEmpty || !numberPattern.hasMatch(newNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number.'),
        ),
      );
      return;
    }

    FirebaseFirestore.instance
        .collection('driverContacts')
        .doc(widget.documentId)
        .update({
      'driverName': newName,
      'driverNumber': newNumber,
    }).then((_) {
      Navigator.of(context).pop(); // Close the current screen
    }).catchError((error) {
      //print('Error updating driver: $error');
    });

    // Show success dialog here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Success'),
          content: Text('Driver Updated successfully.'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Driver Name'),
            ),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => _updateDriver(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// User Screen
class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('driverContacts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var contact = snapshot.data?.docs[index].data();
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person),
                ),
                title: Text(contact?['driverName'] ?? 'No name'),
                subtitle: Text(contact?['driverNumber'] ?? 'No number'),
              );
            },
          );
        },
      ),
    );
  }
}
