import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/model/request_model.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';

class CustomerRequestProvider with ChangeNotifier {
  List<Request> _requests = [];
 var _user =  FirebaseAuth.instance.currentUser;

  bool _isLoading = false;

  bool get getLoading {
    return _isLoading;
  }

  List<Request> get getRequests {
    return _requests;
  }

 

  Future<Null> fetch_requests() async {
     print("mo######");
    try {
      _isLoading = true;
      notifyListeners();
 var _userr =  FirebaseAuth.instance.currentUser;
      print("provider######");
       QuerySnapshot data = await
          FirebaseFirestore.instance.collection("requests/${_userr!.uid}/sub").orderBy("created_at",descending: true).get();

  // QuerySnapshot data = await requestRef.get();
      print("subS##^%%%");
      final List<Request> responseRequest = [];
      data.docs.forEach((requestData) {
        // Map<String,dynamic> resdata = requestData as Map<String,dynamic>;
        print("ui#@@r%%#");
         print(requestData.data());
        Request request=Request(
          uid: requestData.id,
          amount: requestData.get("amount").toDouble(),
        customer_id:requestData.get("customer_id"),
        customer_phone: requestData.get("customer_phone"),
        customer_name: requestData.get("customer_name"),
        customer_location: requestData.get("location"),
        paymentMode: requestData.data().toString().contains("paymentMode")? requestData.get("paymentMode"):1,
        requestStatus: requestData.get("requestStatus"),
        service_id: requestData.get("sub_service_id"),
        parent_service_id: requestData.get("parent_service_id"),
        service_name: requestData.get("service_name"),
        userType: requestData.get("userType"),
        request_address: requestData.data().toString().contains("address")?requestData.get("address"):"",
        destination_address: requestData.data().toString().contains("address_destination")?requestData.get("address_destination"):"",
        createdTime: requestData.data().toString().contains("created_at")?requestData.get("created_at"):"",
         );
        responseRequest.add(request);
      });
      _requests = responseRequest;
      print("ee@2");
      print(_requests.length);
      _isLoading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      print("error");
      print(e.message);
    }
  }


}
