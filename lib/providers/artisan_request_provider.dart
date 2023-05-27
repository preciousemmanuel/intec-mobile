import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class ArtisanRequestProvider with ChangeNotifier {
  var _user = FirebaseAuth.instance.currentUser;
  CollectionReference userRef = FirebaseFirestore.instance.collection("users");

  bool _is_loading = false;
  bool _is_submitting = false;
  bool _is_submitting_arrived = false;

  bool get loading {
    return _is_loading;
  }

  bool get getSubmitting {
    return _is_submitting;
  }
bool get getSubmittingArrived {
    return _is_submitting_arrived;
  }
  
  Future<Map<String, dynamic>> artisanIveArrived(order_id) async {
    try {
      _is_submitting_arrived = true;
      notifyListeners();

      var tokenRes = await _user!.getIdTokenResult();

      print("##for##c");
      _is_submitting_arrived = false;

      print(tokenRes.token ?? "");
      final http.Response response = await http.post(
          Uri.parse("${base_url}payment/artisan-arrived"),
          body: json.encode({
            "order_id": order_id,

            // "location":location
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${tokenRes.token}"
          });
          Map<String,dynamic> respData=json.decode(response.body);
           _is_submitting_arrived = false;
      notifyListeners();
          print("sucess#");
          print(respData);
          if (respData["success"]) {
            return {"status": true, "message": "Marked as arrived"};
          } else {
            return {"status": false, "message": respData["message"]};
          }
      
    } on FirebaseException catch (e) {
      _is_submitting_arrived = false;
      notifyListeners();
      print(e.message);
      return {"status": false, "message": e.message};
    }
  }

  Future<Map<String, dynamic>> acceptRequest(order_id) async {
    try {
      _is_loading = true;
      notifyListeners();

      var tokenRes = await _user!.getIdTokenResult();

      print("##for##c");
      _is_loading = false;

      print(tokenRes.token ?? "");
      final http.Response response = await http.post(
          Uri.parse("${base_url}payment/accept-request"),
          body: json.encode({
            "order_id": order_id,

            // "location":location
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${tokenRes.token}"
          });
          Map<String,dynamic> respData=json.decode(response.body);
           _is_loading = false;
      notifyListeners();
          print("sucess#");
          print(respData);
          if (respData["success"]) {
            return {"status": true, "message": "Request Accepted Successfully"};
          } else {
            return {"status": false, "message": respData["message"]};
          }
      
    } on FirebaseException catch (e) {
      _is_loading = false;
      notifyListeners();
      print(e.message);
      return {"status": false, "message": e.message};
    }
  }

  Future<Map<String, dynamic>> cancelRequest(
      order_id, userCancelledType, reason) async {
    try {
      _is_loading = true;
      notifyListeners();

      var tokenRes = await _user!.getIdTokenResult();

      print("##for##c");
      

      print(tokenRes.token ?? "");
      final http.Response response = await http.post(
          Uri.parse("${base_url}payment/cancel-request"),
          body: json.encode({
            "order_id": order_id,
            "userCancelledType": userCancelledType,
            "reason": reason

            // "location":location
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${tokenRes.token}"
          });
          _is_loading=false;
          notifyListeners();
      return {"status": true, "message": "Request Cancelled Successfully"};
    } on FirebaseException catch (e) {
      _is_loading = false;
      notifyListeners();
      print(e.message);
      return {"status": false, "message": e.message};
    }
  }



  Future<Map<String, dynamic>> confirmRequestComplete(
      order_id) async {
    try {
      _is_submitting = true;
      notifyListeners();

      var tokenRes = await _user!.getIdTokenResult();

      print("##for##c");
      

      print(tokenRes.token ?? "");
      final http.Response response = await http.post(
          Uri.parse("${base_url}payment/confirm-request-complete"),
          body: json.encode({
            "order_id": order_id,
            "confirmed_at": Timestamp.now().toDate().toString(),
           

            // "location":location
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${tokenRes.token}"
          });
          Map<String,dynamic> resMap=json.decode(response.body);
          _is_submitting = false;
          notifyListeners();
          if (resMap["success"]) {
             return {"status": true, "message": "Request Successfully"};
          } else {
             return {"status": false, "message": resMap["message"]};
          }
     
    }  catch (e) {
      _is_submitting = false;
      notifyListeners();
      print("eri##");
      print(e);
      return {"status": false, "message": e.toString()};
    }
  }


}
