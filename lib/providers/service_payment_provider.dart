import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intechpro/config.dart';

class ServicePaymentProvider with ChangeNotifier {
  bool _isSubmitting = false;

  bool get isSubmitting {
    return _isSubmitting;
  }

  Future<Map<String, dynamic>> cancelRequest(
      request_id, reason, userCancelledType) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var tokenRes = await user!.getIdTokenResult();

      print("token");
      print(tokenRes);
      print(tokenRes.token);
      print("locarion");
      print(Timestamp.now().toString());
      print(Timestamp.now().toDate().toString());
// print(location);
      _isSubmitting = true;
      notifyListeners();
      print("${base_url}payment/cancel-request");
      final Response response = await http.post(
          Uri.parse("${base_url}payment/cancel-request"),
          body: json.encode({
            "order_id": request_id,
            "userCancelledType": userCancelledType,
            "reason": reason,

            // "location":location
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${tokenRes.token}"
          });
      print("response%%%###");
      print(response.body);
      print(response.statusCode);
      _isSubmitting = false;
      notifyListeners();
      if (response.statusCode != 200) {
        return {
          "status": false,
          "message": json.decode(response.body)["error"]
        };
        print("failed");
      }
      final Map<String, dynamic> result = json.decode(response.body);
      print("result");
      print(result);
      if (result["success"]) {
        return {"status": true, "message": "Cancelled successully"};
      }

      return {"status": false, "message": result["message"]};
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      print("error payment");
      print(e);
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> approveArtisanPayment(request_id) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var tokenRes = await user!.getIdTokenResult();

// print(location);
      _isSubmitting = true;
      notifyListeners();
      print("${base_url}payment/request-confirm-payment");
      final Response response = await http.post(
          Uri.parse("${base_url}payment/request-confirm-payment"),
          body: json.encode({
            "order_id": request_id,
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${tokenRes.token}"
          });
      print("response%%%###");
      print(response.body);
      print(response.statusCode);
      _isSubmitting = false;
      notifyListeners();
      if (response.statusCode != 200) {
        return {
          "status": false,
          "message": json.decode(response.body)["error"]
        };
        print("failed");
      }
      final Map<String, dynamic> result = json.decode(response.body);
      print("result");
      print(result);
      if (result["success"]) {
        return {"status": true, "message": "Cancelled successully"};
      }

      return {"status": false, "message": result["message"]};
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      print("error payment");
      print(e);
      return {"status": false, "message": e.toString()};
    }
  }


  Future<Map<String, dynamic>> denyArtisanPayment(request_id,reason) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var tokenRes = await user!.getIdTokenResult();

// print(location);
      _isSubmitting = true;
      notifyListeners();
      print("${base_url}payment/request-deny-payment");
      final Response response = await http.post(
          Uri.parse("${base_url}payment/request-deny-payment"),
          body: json.encode({
            "order_id": request_id,
            "reason":reason
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${tokenRes.token}"
          });
      print("response%%%###");
      print(response.body);
      print(response.statusCode);
      _isSubmitting = false;
      notifyListeners();
      if (response.statusCode != 200) {
        return {
          "status": false,
          "message": json.decode(response.body)["error"]
        };
        print("failed");
      }
      final Map<String, dynamic> result = json.decode(response.body);
      print("result");
      print(result);
      if (result["success"]) {
        return {"status": true, "message": "Cancelled successully"};
      }

      return {"status": false, "message": result["message"]};
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      print("error payment");
      print(e);
      return {"status": false, "message": e.toString()};
    }
  }

// Future<Map<String,dynamic>> handleCardPayment(service_name,service_id,parent_service_id,userType,amount,lat,long,address) async{
// try {

//    var user =  FirebaseAuth.instance.currentUser;
// var tokenRes=await  user!.getIdTokenResult();

// print("token");
// print(tokenRes);
// print(tokenRes.token);
// print("locarion");
// print(Timestamp.now().toString());
// print(Timestamp.now().toDate().toString());
// // print(location);
//   _isSubmitting=true;
//   notifyListeners();

//   final Response response=await http.post(Uri.parse("${base_url}payment/pay-card"),body:json.encode({
//     "address":address,
//     "amount":amount,
//     "created_at":Timestamp.now().toDate().toString(),
//     "service_name":service_name,
//     "sub_service_id":service_id,
//     "parent_service_id":parent_service_id,
//     "userType":userType,
//     "location":{
//       "lat":lat,
//       "lon":long
//     }
//     // "location":location
//   }),headers:{
//     "Content-Type": "application/json",
//     "Authorization":"Bearer ${tokenRes.token}"
//   } );
//   print("response%%%###");
//   print(response.body);
//   print(response.statusCode);
//   _isSubmitting=false;
//   notifyListeners();
// if(response.statusCode!=200){
//   return { "status":false,"message":json.decode(response.body)["error"]};

// }
//  final Map<String,dynamic> result = json.decode(response.body);
//  print("result");
//  print(result);
//  if (result["status"]) {
//    return result;
//  }

//  return { "status":false,"message":"Failed to make payment"};

// } catch (e) {
// _isSubmitting=false;
// notifyListeners();
// print("error payment");
// print(e);
// return{"status":false,"message":"Something went wrong"};
// }
// }

  Future<Map<String, dynamic>> handleRequestArtisan(
      service_name,
      selected_trip,
      service_id,
      parent_service_id,
      userType,
      amount,
      lat,
      long,
      address,
      paymentMode,
      addressDestination,
      latDest,
      lonDest) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var tokenRes = await user!.getIdTokenResult();

      print("token");
      print(tokenRes);
      print(tokenRes.token);
      print("locarion");
      print(Timestamp.now().toString());
      print(Timestamp.now().toDate().toString());
// print(location);
      _isSubmitting = true;
      notifyListeners();
      print("ui###nj");
      print(Uri.parse("${base_url}payment/request-artisan"));
      final Response response = await http.post(
          Uri.parse("${base_url}payment/request-artisan"),
          body: json.encode({
            "address": address,
            "selected_trip": selected_trip,
            "amount": amount,
            "created_at": Timestamp.now().toDate().toString(),
            "service_name": service_name,
            "sub_service_id": service_id,
            "parent_service_id": parent_service_id,
            "userType": userType,
            "location": {"lat": lat, "lon": long},
            "address_destination": addressDestination,
            "destLocation": {"lat": latDest, "lon": lonDest}
            // "location":location
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${tokenRes.token}"
          });
      print("response%%%###");
      print(response.body);
      print(response.statusCode);
      _isSubmitting = false;
      notifyListeners();
      if (response.statusCode != 200) {
        return {
          "status": false,
          "message": json.decode(response.body)["error"]
        };
        print("failed");
      }
      final Map<String, dynamic> result = json.decode(response.body);
      print("result");
      print(result);
      if (result["status"]) {
        return result;
      }

      return {"status": false, "message": "Failed to make wallet payment"};
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      print("error payment");
      print(e);
      return {"status": false, "message": "Something went wrong"};
    }
  }

  Future<Map<String, dynamic>> handleWalletPayment(
      service_name,
      selected_trip,
      service_id,
      parent_service_id,
      userType,
      amount,
      lat,
      long,
      address,
      paymentMode,
      order_id) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var tokenRes = await user!.getIdTokenResult();

      print("token");
      print(tokenRes);
      print(tokenRes.token);
      print("locarion");
      print(Timestamp.now().toString());
      print(Timestamp.now().toDate().toString());
// print(location);
      _isSubmitting = true;
      notifyListeners();
      print("ui###nj");
      String url = "";
      if (paymentMode == 1) {
        url = "${base_url}payment/pay-card";
      } else if (paymentMode == 2) {
        url = "${base_url}payment/pay-wallet";
      } else {
        url = "${base_url}payment/pay-cash";
      }
      print(url);
      final Response response = await http.post(Uri.parse(url),
          body: json.encode({
            //"address":address,
            "selected_trip": selected_trip,
            "amount": amount,
            "order_id": order_id,
            //"created_at":Timestamp.now().toDate().toString(),
            //"service_name":service_name,
            //"sub_service_id":service_id,
            // "parent_service_id":parent_service_id,
            // "userType":userType,
            // "location":{
            //   "lat":lat,
            //   "lon":long
            // }
            // "location":location
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${tokenRes.token}"
          });
      print("response%%%###");
      print(response.body);
      print(response.statusCode);
      _isSubmitting = false;
      notifyListeners();
      if (response.statusCode != 200) {
        return {
          "status": false,
          "message": json.decode(response.body)["error"]
        };
        print("failed");
      }
      final Map<String, dynamic> result = json.decode(response.body);
      print("result");
      print(result);
      if (result["status"]) {
        return result;
      }

      return {"status": false, "message": "Failed to make wallet payment"};
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      print("error payment");
      print(e);
      return {"status": false, "message": "Something went wrong"};
    }
  }
}
