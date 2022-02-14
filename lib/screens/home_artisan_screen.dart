

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intechpro/model/user.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/providers/user_location_provider.dart';
import 'package:intechpro/screens/artisan/home_screen.dart';
import 'package:intechpro/screens/artisan/profile_screen.dart';
import 'package:intechpro/screens/complete_artisan_profile_screen.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:dart_geohash/dart_geohash.dart';

import 'package:provider/provider.dart';

import '../config.dart';

class HomeArtisanScreen extends StatefulWidget {
  const HomeArtisanScreen({Key? key}) : super(key: key);

  @override
  _HomeArtisanScreenState createState() => _HomeArtisanScreenState();
}

class _HomeArtisanScreenState extends State<HomeArtisanScreen> {
  int _selectedIndex = 0; 
  Location location = Location();
 late StreamSubscription _getPositionSubscription;
  var user =  FirebaseAuth.instance.currentUser;
  CollectionReference userRef=FirebaseFirestore.instance.collection("users");
var geoHasher = GeoHasher();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoc();
    //check if artisan has chosen the area of specialization and bank details
     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    checkArtisanSetting();
    });
  }

  @override
  dispose(){
super.dispose();
_getPositionSubscription.cancel();
  }


  
  getLoc() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.changeSettings(accuracy: LocationAccuracy.low,interval: 30000,distanceFilter: 5);

   
    // _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
  _getPositionSubscription= location.onLocationChanged.listen((LocationData currentLocation) {
      print("${base_url}payment/hash-location");
      Map<String,dynamic> location_hash={
        "lon":currentLocation.longitude,
        "lat":currentLocation.latitude
      };
      Provider.of<UserLocationProvider>(context,listen:false).updateLocation(location_hash);
      http.post(Uri.parse("${base_url}payment/hash-location"),body: json.encode({
        "location":location_hash
      }),headers: {"Content-Type": "application/json"}).then((http.Response response){
        print("response data");
        print(response.body);
var geoHash=json.decode(response.body);
print(geoHash["hash"]);
 Map<String,dynamic> location={"longitude":currentLocation.longitude,"latitude":currentLocation.latitude,"geoHash":geoHash["hash"]};
      userRef.doc(user!.uid).update({
        "location":location
      });
      });
      // print("location");
      // print("${currentLocation.longitude} : ${currentLocation.longitude}");
     
      // print(geoHasher.encode(-98, 38));
      // print(geoHasher.encode(currentLocation.latitude,currentLocation.longitude));
      // userRef.doc(user.uid).update({
      //   "location"
      // });
     
    });
  }

  void checkArtisanSetting() {
    Profile profile = Provider.of<ProfileProvider>(context,listen: false).profile;
    if (profile.serviceId == null || profile.serviceId == "" || profile.subServiceId==""|| profile.subServiceId==null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(
            userType: profile.userType,
          ),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
  
}

static const List<Widget> _pages = <Widget>[
 HomeScreen(),
 ProfileScreen()
];

Future<bool> _onBackPressed()async {
  return await showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to exit App'),
      actions: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text("NO"),
        ),
        SizedBox(height: 16),
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(true),
          child: Text("YES"),
        ),
      ],
    ),
  ) ??
      false;
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: _pages.elementAt(_selectedIndex),
       
        // body:  Navigator(
        //   onGenerateRoute: (settings) {
        //     print("settingf");
        //     print(settings.name);
        //     Widget page = HomeScreen();
        //     // if (_selectedIndex == 1) page = ProfileScreen();
        //     return MaterialPageRoute(builder: (_) => page);
        //   },
        // ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
         // type: BottomNavigationBarType.shifting,
          elevation: 20,
          // unselectedLabelStyle: TextStyle(fontSize: 14,color: Colors.grey),
          // unselectedItemColor: Colors.grey,
          // unselectedIconTheme: IconThemeData(color: Colors.grey),
          iconSize: 25,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
           onTap: _onItemTapped,  
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
          icon: Icon(Icons.plumbing),
          label: 'My Requests',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
          ],
        ),
      ),
    );
  }
}
