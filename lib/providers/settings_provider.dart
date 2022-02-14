import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intechpro/model/setting.dart';


class SettingProvider with ChangeNotifier {
 bool _isLoading = false;
 late Setting _setting;

  bool get getLoading {
    return _isLoading;
  }

  Setting get setting{
    return _setting;
  }


Future<Null> fetch_setting() async {
  try {
     _isLoading = true;
      notifyListeners();

    CollectionReference settingRef =
          FirebaseFirestore.instance.collection("settings");

          DocumentSnapshot docData= await settingRef.doc("OWBHfWiZ10SERKcKcj1H").get();
          print("jk###");
  print(docData.data());
  _setting=Setting(about: docData.get("about"),faq: docData.get("faq"),terms: docData.get("terms"));
  _isLoading=false;
  notifyListeners();
  } catch (e) {
    print("ssdrr##");
print(e.toString());
_isLoading=false;
  notifyListeners();
  }



}
}