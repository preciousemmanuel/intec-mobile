import 'package:flutter/material.dart';


class UserLocationProvider with ChangeNotifier {
late Map<String,dynamic> _location; 

Map<String,dynamic> get getUserLocatiion{
  return _location;
}

void updateLocation(location){
  print("providerHEr##");
  print(location);
_location=location;
notifyListeners();

}

}