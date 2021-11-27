import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';

class ServiceProvider with ChangeNotifier {
  List<Service> services = [];
  List<SubService> subservices = [];

  bool isLoading = false;

  bool get getLoading {
    return isLoading;
  }

  List<Service> get getServices {
    return services.where((service) => service.visible).toList();
  }

  List<SubService> get getSubServices {
    return subservices.where((service) => service.visible).toList();
  }

  Future<Null> fetch_subservices(serviceId) async {
    try {
      isLoading = true;
      notifyListeners();
      print("provider######");
      CollectionReference serviceRef =
          FirebaseFirestore.instance.collection("subServices/$serviceId/sub");

      QuerySnapshot data = await serviceRef.get();
      print("subS##^%%%");
      final List<SubService> responseService = [];
      data.docs.forEach((serviceData) {
        print("ui#@@r%%#");
        print(serviceData.data());
        final SubService service = SubService(
          name: serviceData.data()["name"],
          uid: serviceData.id,
          visible: serviceData.data()["visible"],
          cost: serviceData.data()["cost"],
        );
        responseService.add(service);
      });
      subservices = responseService;
      print("ee@2");
      print(subservices.length);
      isLoading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      print("error");
      print(e.message);
    }
  }

  Future<Null> fetch_services() async {
    try {
      isLoading = true;
      notifyListeners();
      print("provider######");
      CollectionReference serviceRef =
          FirebaseFirestore.instance.collection("services");

      QuerySnapshot data = await serviceRef.get();
      print("data^%%%");
      final List<Service> responseService = [];
      data.docs.forEach((serviceData) {
        print("forEac%%#");
        print(serviceData.data());
        final Service service = Service(
            name: serviceData.data()["name"],
            uid: serviceData.id,
            visible: serviceData.data()["visible"]);
        responseService.add(service);
      });
      services = responseService;
      isLoading = false;
      notifyListeners();
      print(data.docs[0].data());
    } on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      print("error");
      print(e.message);
    }
  }
}
