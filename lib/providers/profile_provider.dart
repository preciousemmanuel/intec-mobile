import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/model/user.dart';

class ProfileProvider with ChangeNotifier {
  CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  Profile _user = Profile(
      name: "",
      email: "",
      token: "",
      uid: "",
      location: {},
      verified: false,
      blocked: false,
      userType: 0,
      phone: "");
  bool _is_loading = false;
  bool _is_submitting = false;

  bool get loading {
    return _is_loading;
  }

  bool get getSubmitting {
    return _is_submitting;
  }

  Profile get profile {
    return _user;
  }

  bool signout() {
    _user = Profile(
        name: "",
        email: "",
        token: "",
        uid: "",
        location: {},
        userType: 0,
        phone: "");
    notifyListeners();
    return true;
  }


   Future<Map<String, dynamic>> fetch_subcription_amount() async {
    try {
      
      _is_loading = true;
      notifyListeners();
      CollectionReference subRef = FirebaseFirestore.instance.collection("subcription");

      DocumentSnapshot subData = await subRef.doc("qOoagbgE66qT8v4oJ2I8").get();
      print(subData.get("amount"));
      print("fetucwe##");
      

      print("##for##c");
      _is_loading = false;
      notifyListeners();
       return {"status": true,"data":subData.get("amount")};
   
    } on FirebaseException catch (e) {
      print("ëee##");
      print(e.message);
      _is_loading = false;
      notifyListeners();
      return {"status": false, "message": "Failed to fetch user"};
    }
  }

  Future<Map<String, dynamic>> fetch_user() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      _is_loading = true;
      notifyListeners();

      DocumentSnapshot userData = await userRef.doc(user!.uid).get();
      print(userData.data());
      print("fetucwe##");
      print(userData.get("userType"));

      print("##for##c");
      _is_loading = false;
      notifyListeners();
      if (userData.exists) {
        var tokenRes = await user.getIdTokenResult();
        print(tokenRes.token ?? "");
        // if(userData.get("")){

        // }
        _user = Profile(
          name: userData.get("name"),
          email: userData.get("email"),
          token: tokenRes.token ?? "",
          uid: userData.id,
          location: userData.data().toString().contains("location")
              ? userData.get("location")
              : {"lon": 0.00, "lang": 0.00},
          userType: userData.get("userType"),
          phone: userData.get("phone"),
          serviceId: userData.data().toString().contains("serviceId")
              ? userData.get("serviceId")
              : "",
          hasSubscribed: userData.data().toString().contains("hasSubscribed")
              ? userData.get("hasSubscribed")
              : false,
          verified: 
               userData.get("verified"),
          blocked: userData.data().toString().contains("blocked")
              ? userData.get("blocked")
              : false,
          expired: userData.data().toString().contains("expired")
              ? userData.get("expired")
              : false,
          subServiceId: userData.data().toString().contains("subServiceId")
              ? userData.get("subServiceId")
              : "",
          address: userData.data().toString().contains("address")
              ? userData.get("address")
              : "",
          state: userData.data().toString().contains("state")
              ? userData.get("state")
              : "",
        );
        
        notifyListeners();
        return {"status": true, "user": _user};
      }
      return {"status": false, "message": "Failed to fetch user"};
    } on FirebaseException catch (e) {
      _is_loading = false;
      notifyListeners();
      return {"status": false, "message": "Failed to fetch user"};
    }
  }

  void resetProfile() {
    _user = Profile(
        name: "",
        email: "",
        token: "",
        uid: "",
        location: {},
        serviceId: "",
        subServiceId: "",
        blocked: false,
        verified: true,
        userType: 0,
        phone: "");
    notifyListeners();
  }

  Future<Map<String, dynamic>> handleSubscription() async {
    try {
      _is_submitting = true;
      notifyListeners();
      var user = FirebaseAuth.instance.currentUser;
      userRef.doc(user!.uid).update({"expired": false, "hasSubscribed": true});

      print("here##");
      print(_user.name);
      Profile newUser = Profile(
          serviceId: _user.serviceId,
          subServiceId: _user.subServiceId,
          email: _user.email,
          name: _user.name,
          userType: _user.userType,
          uid: _user.uid,
          phone: _user.phone,
          token: _user.token,
          address: _user.address,
          active: _user.active,
          hasSubscribed: true,
          expired: false,
          busy: _user.busy,
          location: _user.location);

      _user = newUser;
      _is_submitting = false;
      print("success###rt");
      notifyListeners();
      return {"status": true};
    } on FirebaseException catch (e) {
      _is_submitting = false;
      notifyListeners();
      return {"status": false, "message": e.message};
    }
  }

  Future<Map<String, dynamic>> updateprofileStatus(bool status) async {
    try {
      _is_submitting = true;
      notifyListeners();
      var user = FirebaseAuth.instance.currentUser;
      userRef.doc(user!.uid).update({
        "active": status,
      });

      print("here##");
      print(_user.name);
      Profile newUser = Profile(
          serviceId: _user.serviceId,
          subServiceId: _user.subServiceId,
          email: _user.email,
          name: _user.name,
          userType: _user.userType,
          uid: _user.uid,
          phone: _user.phone,
          token: _user.token,
          address: _user.address,
          active: status,
          expired: _user.expired,
          hasSubscribed: _user.hasSubscribed,
          busy: _user.busy,
          location: _user.location);

      _user = newUser;
      _is_submitting = false;
      notifyListeners();
      return {"status": true};
    } on FirebaseException catch (e) {
      _is_submitting = false;
      notifyListeners();
      return {"status": false, "message": e.message};
    }
  }

  Future<Map<String, dynamic>> updateprofile(
      String name, String phone, String address) async {
    try {
      _is_submitting = true;
      notifyListeners();
      var user = FirebaseAuth.instance.currentUser;
      user!.updateDisplayName(name);

      userRef
          .doc(user.uid)
          .update({"name": name, "phone": phone, "address": address});

      print("here##");
      print(_user.name);
      Profile newUser = Profile(
          serviceId: _user.serviceId,
          subServiceId: _user.subServiceId,
          email: _user.email,
          name: name,
          userType: _user.userType,
          uid: _user.uid,
          phone: _user.phone,
          token: _user.token,
          address: address,
          expired: _user.expired,
          active: _user.active,
          hasSubscribed: _user.hasSubscribed,
          busy: _user.busy,
          location: _user.location);

      _user = newUser;
      _is_submitting = false;
      notifyListeners();
      return {"status": true, "message": "Profile Updated Successfully!"};
    } on FirebaseException catch (e) {
      _is_submitting = false;
      notifyListeners();
      return {"status": false, "message": e.message};
    }
  }

  Future<Map<String, dynamic>> saveArtisanWorkCategory(
      serviceId, subServiceId) async {
    try {
      _is_submitting = true;
      notifyListeners();
      var user = FirebaseAuth.instance.currentUser;
      userRef.doc(user!.uid).update({
        "serviceId": serviceId,
        "subServiceId": subServiceId,
      });

      print("here##");
      print(_user.name);
      Profile newUser = Profile(
          serviceId: serviceId,
          subServiceId: subServiceId,
          email: _user.email,
          name: _user.name,
          userType: _user.userType,
          uid: _user.uid,
          phone: _user.phone,
          token: _user.token,
          location: _user.location);

      _user = newUser;
      _is_submitting = false;
      notifyListeners();
      return {"status": true};
    } on FirebaseException catch (e) {
      _is_submitting = false;
      notifyListeners();
      return {"status": false, "message": e.message};
    }
  }
}
