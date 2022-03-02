// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intechpro/config.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';

class AuthenticationService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Map<String, dynamic>> signIn(String password, String email) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print("signin auth");
      return {"status": true, "message": "Success"};
    } on FirebaseAuthException catch (e) {
      print("Firebase auth");
      print(e);
      return {"status": false, "message": e.message};
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print("forgot#");
      return {
        "status": true,
        "message": "Password reset link has been sent to your email"
      };
    } on FirebaseAuthException catch (e) {
      print("Firebase auth");
      print(e);
      return {"status": false, "message": e.message};
    }
  }

  Future<Map<String, dynamic>> signUp(
      String fullname,
      String password,
      String phoneNumber,
      String email,
      int userType,
      String address,
      String state,
      String identityType,
      String identityNumber) async {
    try {
      var data = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("succeReg");
      print(data);

      //update the display name

      var user = FirebaseAuth.instance.currentUser;
      //add phone number
      data.user!.updateDisplayName(fullname);
      // user.updateProfile(displayName: fullname);

      //add usertype to user collection
      //CollectionRefere
      CollectionReference users =
          FirebaseFirestore.instance.collection("users");

      CollectionReference walletRef =
          FirebaseFirestore.instance.collection("wallet");

      users.doc(user!.uid).set({
        "name": fullname,
        "userType": userType,
        "email": email,
        "phone": phoneNumber,
        "active": true,
        "state": state,
        "address": address,
        "identityType": identityType,
        "identityNumber": identityNumber,
        "busy": false,
        "expired": false,
        "created_at": Timestamp.now().toDate().toString(),
        "hasSubscribed": false,
        "blocked": false,
        "verified": userType == 1 ? true : false
      });

//credit only customers 1000 naira.
      await walletRef.doc(user.uid).set({
        "amount": userType == 1 ? 0 : 0,
      });

       http.post(Uri.parse("${base_url}user/register-email"),body: json.encode({
         "name": fullname,
        "userType": userType,
        "email": email,
        "phone": phoneNumber,
        "active": true,
        "state": state,
        "address": address,
        "identityType": identityType,
        "identityNumber": identityNumber,
        "busy": false,
        "expired": false,
        "created_at": Timestamp.now().toDate().toString(),
        "hasSubscribed": false,
        "blocked": false,
        "verified": userType == 1 ? true : false
      }),headers: {"Content-Type": "application/json"})
      .then((http.Response response){
        print("suces#s");

        print(response.body);
      });

      return {"status": true, "message": "Success"};
    } on FirebaseAuthException catch (e) {
      print("Firebase auth");
      print(e);
      return {"status": false, "message": e.message};
    }
  }
}
