import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location_track/locations/admin_bus.dart';
import 'package:location_track/screens/HomePage.dart';
import 'package:location_track/screens/HomePage_User.dart';
import 'package:location_track/screens/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final Function(dynamic email) onLogin;

  const LoginScreen({Key? key, required this.onLogin}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? role = prefs.getString('role');

    if (email != null && role != null) {
      if (role == 'admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(userEmail: email),
          ),
        );
      } else if (role == 'user') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePageUser(userEmail: email),
          ),
        );
      } else if (role == 'driver') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => admin_bus(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Your Email!!";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return "Please Enter a Valid Email";
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: "Email",
        prefixIcon: Icon(Icons.mail),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _obscureText,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Password is required for login";
        }
        if (!regex.hasMatch(value)) {
          return "Enter Valid Password (Min. 6 Characters)";
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: Icon(Icons.vpn_key),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue.shade900,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 194, 187, 187),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Card(
              elevation: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        "Go By Bus \n System",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Hey! Good to see you!",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      emailField,
                      const SizedBox(height: 25),
                      passwordField,
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _showForgotPasswordDialog();
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      loginButton,
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    TextEditingController forgotPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password Request'),
          content: TextField(
            controller: forgotPasswordController,
            decoration:
                const InputDecoration(hintText: "Enter your Username/Email"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String email = forgotPasswordController.text.trim();
                if (email.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('ChangePassRequest')
                      .add({
                    'email': email,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  Fluttertoast.showToast(msg: "Request sent successfully");
                } else {
                  Fluttertoast.showToast(
                      msg: "Please enter a valid email/username");
                }
                Navigator.of(context).pop();
              },
              child: const Text('Send'),
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

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        var userSnapshot = await FirebaseFirestore.instance
            .collection('UserLogin')
            .where('Username', isEqualTo: email)
            .where('Password', isEqualTo: password)
            .get();

        var adminSnapshot = await FirebaseFirestore.instance
            .collection('AdminLogin')
            .where('Username', isEqualTo: email)
            .where('Password', isEqualTo: password)
            .get();

        var driverSnapshot = await FirebaseFirestore.instance
            .collection('DriverLogin')
            .where('username', isEqualTo: email)
            .where('password', isEqualTo: password)
            .get();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (adminSnapshot.docs.isNotEmpty) {
          await prefs.setString('email', email);
          await prefs.setString('role', 'admin');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(userEmail: email),
            ),
          );
          return;
        }

        if (userSnapshot.docs.isNotEmpty) {
          await prefs.setString('email', email);
          await prefs.setString('role', 'user');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePageUser(userEmail: email),
            ),
          );
          return;
        }

        if (driverSnapshot.docs.isNotEmpty) {
          await prefs.setString('email', email);
          await prefs.setString('role', 'driver');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => admin_bus(),
            ),
          );
          return;
        }

        Fluttertoast.showToast(msg: "Invalid Credentials");
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }
}
