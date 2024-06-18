import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsAdminPage extends StatefulWidget {
  const NotificationsAdminPage({Key? key}) : super(key: key);

  @override
  _NotificationsAdminPageState createState() => _NotificationsAdminPageState();
}

class _NotificationsAdminPageState extends State<NotificationsAdminPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedBus = 'All Buses';
  String _notificationMessage = '';
  bool _agreedToTerms = false;
  final List<String> _busOptions = [
    'All Buses',
    'Bus 0',
    'Bus 1',
    'Bus 2',
    'Bus 3',
    'Bus 4'
  ];
  List<Map<String, dynamic>> _sentMessages = [];

  void _sendNotification() async {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      _formKey.currentState!.save();

      List<String> busCollections = [];
      if (_selectedBus == 'All Buses') {
        busCollections = ['Bus0', 'Bus1', 'Bus2', 'Bus3', 'Bus4'];
      } else {
        busCollections = [_selectedBus.replaceAll(' ', '')];
      }

      for (String bus in busCollections) {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection(bus).get();

        for (var doc in querySnapshot.docs) {
          String username = doc.get('Username');
          await FirebaseFirestore.instance.collection('Notifications').add({
            'userEmail': username,
            'message':
                'Notification from admin: $_notificationMessage (Bus: $_selectedBus)',
            'timestamp': FieldValue.serverTimestamp(),
          });

          setState(() {
            _sentMessages.add({
              'username': username,
              'message': _notificationMessage,
              'bus': _selectedBus,
              'timestamp': DateTime.now(),
            });
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notification sent to $username')),
          );
        }
      }
      _formKey.currentState!.reset();
      setState(() {
        _agreedToTerms = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _sentMessages.map((message) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.lightBlueAccent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('To: ${message['username']}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Bus: ${message['bus']}'),
                        Text('Message: ${message['message']}'),
                        Text('Sent: ${message['timestamp'].toString()}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Bus:', style: TextStyle(fontSize: 16)),
                  DropdownButtonFormField<String>(
                    value: _selectedBus,
                    items: _busOptions.map((String bus) {
                      return DropdownMenuItem<String>(
                        value: bus,
                        child: Text(bus),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedBus = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Notification Message:',
                      style: TextStyle(fontSize: 16)),
                  TextFormField(
                    maxLines: 4,
                    onSaved: (value) {
                      _notificationMessage = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a message';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your message here',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value!;
                          });
                        },
                      ),
                      const Text('I agree to the terms and conditions'),
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _sendNotification,
                      child: const Text('Send'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
