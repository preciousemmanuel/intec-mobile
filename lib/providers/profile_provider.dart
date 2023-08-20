import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/model/product.dart';
import 'package:intechpro/model/user.dart';

class ProfileProvider with ChangeNotifier {
  CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  CollectionReference productRef =
      FirebaseFirestore.instance.collection("products");
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

  Product _product = Product(name: "", cost: 0, description: "");
  List<Product> _products = [];
  bool _is_loading = false;
  bool _is_submitting = false;

  bool get loading {
    return _is_loading;
  }

  Product get getProduct {
    return _product;
  }

  List<Product> get getProducts {
    return _products;
  }

  getProductsSearcherd(text) {
    if (text == "") {
    } else {
      List<Product> _prodL =
          _products.where((element) => element.name.contains(text)).toList();
      _products = _prodL;
      notifyListeners();
    }
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
      CollectionReference subRef =
          FirebaseFirestore.instance.collection("subcription");

      DocumentSnapshot subData = await subRef.doc("qOoagbgE66qT8v4oJ2I8").get();
      print(subData.get("amount"));
      print("fetucwe##");

      print("##for##c");
      _is_loading = false;
      notifyListeners();
      return {"status": true, "data": subData.get("amount")};
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
      // print(userData.get("imageurl"));

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
          verified: userData.get("verified"),
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
          imageUrl: userData.data().toString().contains("imageurl")
              ? userData.get("imageurl")
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
          imageUrl: _user.imageUrl,
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
          imageUrl: _user.imageUrl,
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

  Future<Map<String, dynamic>> updateprofileImage(String imageurl) async {
    try {
      _is_submitting = true;
      notifyListeners();
      var user = FirebaseAuth.instance.currentUser;
      user!.updatePhotoURL(imageurl);

      userRef.doc(user.uid).update({"imageurl": imageurl});

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
          expired: _user.expired,
          active: _user.active,
          hasSubscribed: _user.hasSubscribed,
          busy: _user.busy,
          imageUrl: imageurl,
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

  Future<Map<String, dynamic>> createProduct(
      String name, int cost, String description) async {
    try {
      _is_submitting = true;
      notifyListeners();
      var user = FirebaseAuth.instance.currentUser;

      var dataSuc=await productRef
          .doc(user!.uid)
          .collection("sub")
          .add({"name": name, "cost": cost, "description": description, "created_at": Timestamp.now().toDate().toString(), "updated_at": Timestamp.now().toDate().toString(),});

      print("dataSuc##");
      print(dataSuc.id);
      Product newProduct = Product(
        name: name,
        cost: cost,
        description: description,
        uid: dataSuc.id
      );
      _products.add(newProduct);

      _is_submitting = false;
      notifyListeners();
      return {"status": true, "message": "Product created Successfully!"};
    } on FirebaseException catch (e) {
      _is_submitting = false;
      notifyListeners();
      return {"status": false, "message": e.message};
    }
  }

Future<Map<String, dynamic>> updateProduct(
      String name, int cost, String description,String uid) async {
    try {
      _is_submitting = true;
      notifyListeners();
      var user = FirebaseAuth.instance.currentUser;

      productRef
          .doc(user!.uid)
          .collection("sub")
          .doc(uid)
          .update({"name": name, "cost": cost, "description": description, "updated_at": Timestamp.now().toDate().toString(),});

      print("here##");
      print(_user.name);
      Product newProduct = Product(
        name: name,
        cost: cost,
        description: description,
        uid: uid
      );
     
      //update products array
      _products[_products.indexWhere((prod) => prod.uid==uid)]=newProduct;

      _is_submitting = false;
      notifyListeners();
      return {"status": true, "message": "Product created Successfully!"};
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

  Future<Null> fetch_products(userId) async {
    try {
      _is_loading = true;
      notifyListeners();
      print("eW#c#####");

      QuerySnapshot data = await productRef.doc(userId).collection("sub").get();

      print("produc##su^%%%");
      final List<Product> responseProduct = [];
      data.docs.forEach((prodData) {
        print("typodf@@r%%#");
        print(prodData.data());
        final Product prod = Product(
            name: prodData.get("name"),
            uid: prodData.id,
            cost: prodData.get("cost"),
            description: prodData.data().toString().contains("description")
                ? prodData.get("description")
                : "");
        responseProduct.add(prod);
      });
      _products = responseProduct;

      _is_loading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      _is_loading = false;
      notifyListeners();
      print("error");
      print(e.message);
    }
  }

  Future<Map<String,dynamic>> fetch_one_product(productId) async {
    try {
      _is_loading = true;
      notifyListeners();
      print("eW#cproductId");
      print(productId);
      var user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot prodData = await productRef
          .doc(user!.uid)
          .collection("sub")
          .doc(productId)
          .get();

      print("typodf@@r%%#");
      print(prodData.data());
      final Product prod = Product(
          name: prodData.get("name"),
          uid: prodData.id,
          cost: prodData.get("cost"),
          description: prodData.data().toString().contains("description")
              ? prodData.get("description")
              : "");
      _product = prod;

      _is_loading = false;
      notifyListeners();
      return {"product":_product,"status":true};
    } on FirebaseException catch (e) {
      _is_loading = false;
      notifyListeners();
      print("error");
      print(e.message);
      return {"message":e.message.toString(),"status":false};
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
