import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'account_details_page_admin.dart';

class EditProfileAdmin extends StatelessWidget {
  final String userEmail;

  EditProfileAdmin({Key? key, required this.userEmail}) : super(key: key);

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Admin',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(userEmail),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AccountDetailsAdminPage(userEmail: userEmail),
                  ),
                );
              },
              leading: const Icon(Icons.account_circle, color: Colors.blue),
              title: const Text('Account'),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPage(),
                  ),
                );
              },
              leading: const Icon(Icons.lock, color: Colors.blue),
              title: const Text('Privacy'),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              onTap: () {
                _showChangePasswordDialog(context);
              },
              leading: const Icon(Icons.vpn_key, color: Colors.blue),
              title: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String newPassword = newPasswordController.text;
                String confirmPassword = confirmPasswordController.text;

                // Password validation
                if (newPassword.isEmpty || confirmPassword.isEmpty) {
                  _showErrorDialog(context, 'Password fields cannot be empty.');
                  return;
                }

                if (newPassword.length < 6) {
                  _showErrorDialog(
                      context, 'Password must be at least 6 characters long.');
                  return;
                }

                if (!newPassword.contains(RegExp(r'\d'))) {
                  _showErrorDialog(
                      context, 'Password must contain at least one digit.');
                  return;
                }

                if (newPassword != confirmPassword) {
                  _showErrorDialog(context, 'Passwords do not match.');
                  return;
                }

                // Retrieve user data from Firestore
                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    await FirebaseFirestore.instance
                        .collection('AdminLogin')
                        .where('Username', isEqualTo: userEmail)
                        .get();

                if (querySnapshot.docs.isNotEmpty) {
                  // Update password in Firestore
                  querySnapshot.docs.first.reference
                      .update({'Password': newPassword}).then((_) {
                    Navigator.of(context).pop();
                    _showSuccessDialog(
                        context, 'Password updated successfully.');
                  }).catchError((error) {
                    _showErrorDialog(context,
                        'Failed to update password. Please try again.');
                  });
                } else {
                  // ignore: use_build_context_synchronously
                  _showErrorDialog(context, 'User not found.');
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900),
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
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
  }
}

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
