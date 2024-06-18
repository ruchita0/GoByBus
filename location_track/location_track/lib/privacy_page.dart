import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Terms'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Go by Bus Privacy Policy\n\n'
                      'Effective Date: 30/05/2024 \n\n'
                      "Our Go by Bus app respects your privacy. We collect email and password for login, track bus usage and send notifications. We may use anonymous data to improve the app. We never store payment information (processed by secure third-party) and keep uploaded documents confidential. Driver location data helps track buses. You can access and update your information or delete your account anytime.",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _accepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _accepted = value ?? false;
                    });
                  },
                ),
                const Text('I accept'),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: _accepted
                    ? () {
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.blue.shade200,
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
