// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/model/task.dart';

class ServiceProvider with ChangeNotifier {
  List<Service> services = [];
  List<SubService> subservices = [];
  List<Task> _tasks = [];
  Service service = Service(name: "", uid: "", visible: false);
   SubService _subService=SubService(cost: 0,name: "",visible: false,uid: "",serviceId: "");
   late Task _task;



   CollectionReference serviceCollectionRef =
          FirebaseFirestore.instance.collection("services");

  bool isLoading = false;

  bool get getLoading {
    return isLoading;
  }

  Service get getService {
    return service;
  }

   SubService get getSubService {
    return _subService;
  }

   Task get getTask {
    return _task;
  }

   List<Task> get getTasks {
    return _tasks.where((service) => service.visible).toList();
  }

 List<Task> get getSelectedTasks {
    return _tasks.where((service) => service.isSelected==true).toList();
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
          name: serviceData.get("name"),
          uid: serviceData.id,
          serviceId: serviceId,
          hasTask: serviceData.get("hasTask"),
          visible: serviceData.get("visible"),
          cost: serviceData.get("cost"),
          price_guide: serviceData.data().toString().contains("price_guide")? serviceData.get("price_guide"):""
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


selectedTask(index){
  print(_tasks[index].isSelected);
  if(_tasks[index].isSelected==null){
 _tasks[index].isSelected=true;
  }else{
if (!_tasks[index].isSelected!) {
      _tasks[index].isSelected=true;
    } else {
      _tasks[index].isSelected=false;
    }
  }
  print(_tasks);
  notifyListeners();
}

numberOfTaskSelected(index,selected){
  print(_tasks[index].numberSelected);
 
 _tasks[index].numberSelected=selected;

  print(_tasks);
  notifyListeners();
}

unSelectedTask(index){
  _tasks[index].isSelected=false;
  print(_tasks);
  notifyListeners();
}

  
  Future<Null> fetch_suppliers_by_serviceId(serviceId,subServiceId) async {
    try {
      isLoading = true;
      notifyListeners();
      print("psupplier list per###");
      QuerySnapshot data = await  FirebaseFirestore.instance.collection("users").where("serviceId",isEqualTo:serviceId )
       .where("subServiceId",isEqualTo:subServiceId )
        .where("expired",isEqualTo:false )
        .where("hasSubscribed",isEqualTo:true )
       .get();

     
      print("gho##^%%%");
      final List<Task> responseService = [];
      data.docs.forEach((serviceData) {
        print("ui#@@r%%#");
        print(serviceData.data());
        final Task service = Task(
          name: serviceData.get("name"),
          phone: serviceData.get("phone"),
          uid: serviceData.id,
          visible: true,
          cost: 100,
          serviceId: serviceId,
          subServiceId: subServiceId,
          address:serviceData.data().toString().contains("address")? serviceData.get("address"):""
        );
        responseService.add(service);
      });
      _tasks = responseService;
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


  Future<Null> fetch_tasks(serviceId,subServiceId) async {
    try {
      isLoading = true;
      notifyListeners();
      print("provider######");
      CollectionReference serviceRef =
          FirebaseFirestore.instance.collection("tasks/$subServiceId/sub");

      QuerySnapshot data = await serviceRef.get();
      print("subS##^%%%");
      final List<Task> responseService = [];
      data.docs.forEach((serviceData) {
        print("ui#@@r%%#");
        print(serviceData.data());
        final Task service = Task(
          name: serviceData.get("name"),
          uid: serviceData.id,
          visible: serviceData.get("visible"),
          cost: serviceData.get("cost"),
          serviceId: serviceId,
          subServiceId: subServiceId,
          numberSelected: 1
        );
        responseService.add(service);
      });
      _tasks = responseService;
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
   

      QuerySnapshot data = await serviceCollectionRef.get();
      print("data^%%%");
      final List<Service> responseService = [];
      data.docs.forEach((serviceData) {
        print("forEac%%#");
        print(serviceData.data());
        final Service service = Service(
            name: serviceData.get("name"),
            uid: serviceData.id,
            visible: serviceData.get("visible"),
            userType: serviceData.get("userType")
            );
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

  Future<Map<String, dynamic>> fetch_service_and_sub_by_userType(
      userType) async {
    try {
      isLoading = true;
      notifyListeners();
      print("provider######");

      //get service by type
      CollectionReference serviceCollectionRef =
          FirebaseFirestore.instance.collection("services");
      QuerySnapshot serviceQuery = await serviceCollectionRef
          .where("userType", isEqualTo: userType)
          .get();
      if (serviceQuery.size < 1) {
        return {"status": false, "message": "Invalid user type"};
      }
      print("service@##");

      service = Service(
          name: serviceQuery.docs[0].get("name"),
          visible: serviceQuery.docs[0].get("visible"),
          uid: serviceQuery.docs[0].id);

      CollectionReference serviceRef = FirebaseFirestore.instance
          .collection("subServices/${service.uid}/sub");

      QuerySnapshot data = await serviceRef.get();
      print("subS##^%%%");
      final List<SubService> responseService = [];
      data.docs.forEach((serviceData) {
        print("ui#@@r%%#");
        print(serviceData.data());
        final SubService subservice = SubService(
          serviceId: service.uid,
          name: serviceData.get("name"),
          uid: serviceData.id,
          visible: serviceData.get("visible"),
          cost: serviceData.get("cost"),
        );
        responseService.add(subservice);
      });
      subservices = responseService;
      print("ee@2");
      print(subservices.length);
      isLoading = false;
      notifyListeners();

      return {"status": true, "message": "success"};
    } on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      print("error");
      print(e.message);
      return {"status": false, "message": e.message};
    }
  }


Future<Map<String, dynamic>> fetch_service_and_sub_by_id(
      service_id,sub_service_id) async {
    try {
      isLoading = true;
      notifyListeners();
      print("provider######");

      //get service by type
     DocumentSnapshot serviceData=await serviceCollectionRef.doc(service_id).get();
    
    

      service = Service(
          name: serviceData.get("name"),
          visible: serviceData.get("visible"),
          uid: serviceData.id);

      CollectionReference subserviceRef = FirebaseFirestore.instance
          .collection("subServices");

      DocumentSnapshot sub_service_data = await subserviceRef.doc("${service_id}/sub/${sub_service_id}").get();
      print("subS##^%%%");
     
     
        print("ui#@@r%%#");
        print(serviceData.data());
        final SubService subService = SubService(
          serviceId:service_id ,
          name: sub_service_data.get("name"),
          uid: sub_service_data.id,
          visible: sub_service_data.get("visible"),
          cost: sub_service_data.get("cost"),
        );
        
      
      _subService = subService;
      
      isLoading = false;
      notifyListeners();

      return {"status": true, "message": "success"};
    } on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      print("error");
      print(e.message);
      return {"status": false, "message": e.message};
    }
  }

}
