import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macstore/views/screens/main_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;

  User get user => _user.value!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createNewUser(
    String email,
    String fullName,
    String password,
    String phoneNumber,
  ) async {
    String res = 'some error occurred';

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('buyers').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'profileImage': '',
        'email': email,
        'phoneNumber': phoneNumber, // Added phoneNumber field
        'uid': userCredential.user!.uid,
        'pinCode ': "",
        'locality': "",
        'city': '',
        'state': '',
      });

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    Map<String, dynamic> res = {'status': 'error', 'role': ''};

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('buyers')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        res = {
          'status': 'success',
          'role': 'buyer',
        };
      } else {
        res['status'] = 'Invalid user role or user not found.';
      }
    } catch (e) {
      res['status'] = e.toString();
    }

    return res;
  }

  Future<bool> changePassword(BuildContext context, String password) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updatePassword(password);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password Changed'),
          backgroundColor: Colors.blue,
        ));
        print('password Changed');
        return true;
      } else {
        print('User is not authenticated');
        return false;
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.code.toString()),
        backgroundColor: Colors.blue,
      ));
      print(error.code.toString());
      return false;
    }
  }
}
