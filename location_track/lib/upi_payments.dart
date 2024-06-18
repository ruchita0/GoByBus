import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dropdown_model_list/drop_down/model.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class UpiPayment extends StatefulWidget {
  final OptionItem selectedItem;
  final String userEmail; // Add userEmail argument here

  const UpiPayment(
      {Key? key, required this.selectedItem, required this.userEmail})
      : super(key: key);

  @override
  State<UpiPayment> createState() => _UpiPaymentState();
}

class _UpiPaymentState extends State<UpiPayment> {
  late Razorpay _razorpay;
  String? userId; // Variable to hold combined firstName and secondName

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _initiatePayment(); // Start the payment process when the widget is created
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Map<String, String> getBusDetails(String stopTitle) {
    switch (stopTitle) {
      case 'MIDC Chowk - NKOCET':
        return {
          'busNumber': 'Bus 1',
          'fees': '6500',
        };
      case 'Nehru Nagar - NKOCET':
        return {
          'busNumber': 'Bus 2',
          'fees': '6000',
        };
      case 'DMart(Jule Solapur) - NKOCET':
        return {
          'busNumber': 'Bus 3',
          'fees': '6000',
        };
      case 'Saat Rasta - NKOCET':
        return {
          'busNumber': 'Bus 4',
          'fees': '6500',
        };
      default:
        return {
          'busNumber': '',
          'fees': 'Unknown',
        };
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");
    Navigator.pop(context, true); // Return true indicating payment success
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  Future<void> purchase({required String userId, required int amount}) async {
    try {
      final response = await FirebaseFunctions.instance
          .httpsCallableFromUri(
              Uri.parse(
                  'https://asia-south1-location-c67b5.cloudfunctions.net/createPurchase'),
              options: HttpsCallableOptions())
          .call({
        'userId': userId,
        'amount': amount,
      });

      final data = response.data as Map<String, dynamic>;
      final _orderId = data['orderId'] as String?;
      print(_orderId);
      if (_orderId == null) {
        throw Exception("Order ID is null");
      }

      int? razorpayAmount = data['amount'] as int?;
      if (razorpayAmount == null) {
        throw Exception("Amount is null");
      }

      var options = {
        'key': 'rzp_test_ruQgTQV8u0bKB6', // replace with your Razorpay key
        'order_id': _orderId,
        'amount': razorpayAmount * 100, // amount in paise
        'name': 'Bus fees',
        'currency': 'INR',
        'theme': {
          'color': '#F37254',
        },
      };

      _razorpay.open(options);
    } catch (e) {
      print('Error during payment initiation: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'There was an issue initiating the payment. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _initiatePayment() async {
    try {
      // Fetch user details from UserLogin collection based on userEmail
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('UserLogin')
              .where('Username', isEqualTo: widget.userEmail)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the user document reference
        final userDocRef = querySnapshot.docs.first.reference;

        // Get the user data from the first document
        final userData = querySnapshot.docs.first.data();
        final firstName = userData['firstName'] as String?;
        final secondName = userData['secondName'] as String?;

        if (firstName != null && secondName != null) {
          // Combine firstName and secondName
          final userId = '$firstName $secondName';

          // Update the user document with the combined userId
          await userDocRef.update({
            'userId': userId,
          });

          setState(() {
            this.userId = userId;
          });

          // Proceed with initiating the payment
          double amount = double.parse(
              getBusDetails(widget.selectedItem.title)['fees'] ?? '0');
          await purchase(
              userId: userId, // Use the combined userId
              amount: amount.toInt());
        } else {
          throw Exception("User details not found or incomplete");
        }
      } else {
        throw Exception("User data not found");
      }
    } catch (e) {
      print('Error during payment initiation: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'There was an issue initiating the payment. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Razorpay Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text("Initiating the payment, please wait..."),
            if (userId != null) ...[
              const SizedBox(height: 20),
              Text(
                  "User: $userId"), // Display combined firstName and secondName
            ]
          ],
        ),
      ),
    );
  }
}
