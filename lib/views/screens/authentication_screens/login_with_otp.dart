import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macstore/views/screens/main_screen.dart';

class LoginScreenOTP extends StatefulWidget {
  @override
  _LoginScreenOTPState createState() => _LoginScreenOTPState();
}

class _LoginScreenOTPState extends State<LoginScreenOTP> {
  late String phoneNumber;
  late String verificationId = '';
  late String otp;
  late FirebaseAuth _auth;
  late Timer _timer;
  int _resendToken = 0;
  int _timerCount = 120;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  Future<void> _startTimer() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerCount > 0) {
          _timerCount--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  Future<void> _stopTimer() async {
    _timer.cancel();
    setState(() {
      _timerCount = 60;
    });
  }

  // Future<void> _resendOTP() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   String normalizedPhoneNumber = await _normalizePhoneNumber(phoneNumber);

  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: normalizedPhoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await _auth.signInWithCredential(credential);
  //       Navigator.pushReplacementNamed(context, '/home');
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       print('Verification failed: $e');
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       setState(() {
  //         this.verificationId = verificationId;
  //         _resendToken = resendToken!;
  //         _isLoading = false;
  //       });
  //       _startTimer();
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       print('Auto retrieval timeout');
  //     },
  //   );
  // }
  Future<void> _resendOTP() async {
    setState(() {
      _isLoading = true;
    });

    // Ensure the phone number includes the country code prefix
    phoneNumber = '+91' + phoneNumber;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginScreenOTP();
        }));
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
          _resendToken = resendToken!;
          _isLoading = false;
        });
        _startTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Auto retrieval timeout');
      },
    );
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });
// Normalize the phone number
    String normalizedPhoneNumber = await _normalizePhoneNumber(phoneNumber);

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      await _auth.signInWithCredential(credential);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MainScreen();
      }));
    } catch (e) {
      print('Error signing in: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _normalizePhoneNumber(String phoneNumber) async {
    // Check if the phone number starts with '+' (indicating the presence of country code)
    // If not, assume it is an Indian number (+91) and prepend '+91' to the phone number
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+91' + phoneNumber;
    }

    // Remove any non-numeric characters from the phone number
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Return the normalized phone number
    return phoneNumber;
  }

  Future<bool> _checkPhoneNumberExists(String phoneNumber) async {
    String normalizedPhoneNumber = await _normalizePhoneNumber(phoneNumber);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('buyers')
        .where('phoneNumber', isEqualTo: normalizedPhoneNumber)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _resendOTP,
                child:
                    _isLoading ? CircularProgressIndicator() : Text('Get OTP'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Resend OTP in $_timerCount seconds'),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'OTP'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    otp = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOTP,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
