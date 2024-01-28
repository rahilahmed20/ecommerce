import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macstore/views/screens/widgets/button_widget.dart';
import 'package:macstore/views/screens/widgets/custom_text_Field.dart';

class ShippingAddressScreen extends StatefulWidget {
  ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String pinCode;
  late String locality;
  late String city;
  late String state;

  @override
  void initState() {
    super.initState();
    // Fetch and set initial values for text fields
    fetchUserAddress();
  }

  Future<void> fetchUserAddress() async {
    try {
      // Fetch user's address from Firestore
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      // If user's address is present, set initial values for text fields
      if (userSnapshot.exists) {
        setState(() {
          pinCode = userSnapshot['pinCode'] ?? '';
          locality = userSnapshot['locality'] ?? '';
          city = userSnapshot['city'] ?? '';
          state = userSnapshot['state'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching user address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.96),
        title: Text(
          'Delivery',
          style: GoogleFonts.getFont(
            'Lato',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(
            0xFF102DE1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Where will your ordered\nitems be shipped?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
                      child: Text(
                        'Pin Code',
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  CustomTextField(
                    label: 'Enter Your Pin Code',
                    prefixIcon: Icon(null),
                    text: 'Enter pin code',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Pin Code";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      pinCode = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
                      child: Text(
                        'Locality',
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  CustomTextField(
                    label: 'Enter Your Locality',
                    prefixIcon: Icon(null),
                    text: 'Enter locality',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter  Locality";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      locality = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
                      child: Text(
                        'City',
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  CustomTextField(
                    label: 'Enter Your City',
                    prefixIcon: Icon(null),
                    text: 'Enter city',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter City";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      city = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0),
                      child: Text(
                        'State',
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  CustomTextField(
                    label: 'Enter Your State',
                    prefixIcon: Icon(null),
                    text: 'Enter state',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter state";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      state = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonWidgets(
                    isLoading: false,
                    buttonChange: () async {
                      if (_formKey.currentState!.validate()) {
                        _showLoginDialog(context);
                        await _firestore
                            .collection('users')
                            .doc(_auth.currentUser!.uid)
                            .update({
                          "pinCode": pinCode,
                          'locality': locality,
                          'city': city,
                          'state': state,
                        }).whenComplete(() {
                          Navigator.pop(context);
                        });
                      }
                    },
                    buttonTitle: 'Go to Payment',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Updating Address'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Please wait...'),
          ],
        ),
      );
    },
  );

  // Simulate a network call or some asynchronous task
  Future.delayed(Duration(seconds: 3), () {
    // Close the dialog when the task is complete
    Navigator.of(context).pop();
  });
}
