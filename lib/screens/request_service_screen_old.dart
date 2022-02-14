import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intechpro/model/address_suggestion.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/screens/payment_service_screen.dart';
import 'package:intechpro/widgets/address_search.dart';
// import 'package:intechpro/widgets/address_search.dart';
import 'package:location/location.dart' as LocationData;
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_geocoding/google_geocoding.dart';

class RequestServiceScreen extends StatefulWidget {
  SubService subService;
  Service parentService;

  RequestServiceScreen({Key? key, required this.subService,required this.parentService});

  @override
  _RequestServiceScreenState createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  final _textcontroller = TextEditingController();
 late GoogleGeocoding googGeocoding;
  bool _isMapLoaded = false;
  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';

  double latitude = 0.001;
  double longitude = 0.999;
  LocationData.LocationData? currentLocation;
  String _address = "";
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  static LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng _lastMapPosition = _center;

  @override
  initState() {
    print("googleKeuy");
    print(dotenv.env["GOOGLE_API_KEY"]??"");
    googGeocoding=GoogleGeocoding(dotenv.env["GOOGLE_API_KEY"]??"");
    _getLocation();
    super.initState();
  }

  @override
  void dispose() {
    _textcontroller.dispose();
    super.dispose();
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _center = position.target;
    });
  }

  void _getLocation() {
    setState(() {
      _isMapLoaded = true;
    });
    print("init##%%");
    _getLocationData().then((value) {
      print("dpoee");
      print(value);
      LocationData.LocationData? location = value;
      print(location!.latitude);
      // setState(() {
      //   _isMapLoaded = false;
      //   print("du###vf");
      //   _center = LatLng(location.latitude??0.00, location.longitude??0.00);
      // });

      // setState(() {
      //   _center = const LatLng(location.latitude==null?6.000:location.latitude, -122.677433);
      // });

      _getAddress(location.latitude, location.longitude).then((value) {
        print("uyDF#");
        print(value);
        setState(() {
           _isMapLoaded = false;
          currentLocation = location;
          _address = value;
          _center =LatLng(location.latitude??0.00, location.longitude??0.00);
        });
      }).catchError((e) {
        print("preee##");
        print(e);
      });
    });
  }

  //  Future<Coordinates> _getCoordinates(String address) async {
  //   print("add##");
  //   print(address);
  //  // if (address == null || address == "") ;
  //   print("hjo##");
  //   GeoCode geoCode = GeoCode();
  //   Coordinates coordinates =
  //       await geoCode.forwardGeocoding(address: address);
  //   print("codgoed##");
  //   print(coordinates);
  //   return coordinates;
  // }

   Future<Null> _getCoordinates(String address) async {
    print("add##");
    print(address);
   // if (address == null || address == "") ;
    print("code###");
    
    var response =
        await googGeocoding.geocoding.get(address,[]);
        if (response != null && response.results != null) {
          print(response.results![0].geometry!.location!.lat);
          print(response.results![0].geometry!.location!.lng);
           setState(() {
          
         
          _address = address;
          _center =LatLng(response.results![0].geometry!.location!.lat??0.00, response.results![0].geometry!.location!.lng??0.00);
        });
        } 
  
   
  }

  Future<String> _getAddress(double? lat, double? lang) async {
    print("add##");
    print(lat);
    if (lat == null || lang == null) return "";
    print("pass##");
    final LatLon coord=LatLon(lat, lang);
    print(coord);
    var result =
        await googGeocoding.geocoding.getReverse(coord);
    print("opi##");
    print(result!.results![0].formattedAddress);
    return "${result.results![0].formattedAddress}";
    //return "${address.streetAddress}, ${address.city}, ${address.countryName}, ";
  }

  //  Future<String> _getAddress(double? lat, double? lang) async {
  //   print("add##");
  //   print(lat);
  //   if (lat == null || lang == null) return "";
  //   print("pass##");
  //   GeoCode geoCode = GeoCode();
  //   Address address =
  //       await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
  //   print("opi##");
  //   print(address);
  //   return "${address.streetAddress}, ${address.city}, ${address.countryName}, ";
  // }

  Future<LocationData.LocationData?> _getLocationData() async {
    LocationData.Location location = new LocationData.Location();
    LocationData.LocationData _locationData;

    bool _serviceEnabled;
    LocationData.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == LocationData.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != LocationData.PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose Location",
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final sessionToken = Uuid().v4();
                final AddressSuggestion? result = await showSearch(
                    context: context, delegate: AddressSearch(sessionToken));
print("addressSe#del");
                print(result!.description);
                _getCoordinates(result.description);
              },
              icon: const Icon(Icons.search)),
          TextButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => PaymentServiceScreen(
                //               subservice: widget.subService,
                //               parentService: widget.parentService,
                //               location: _center,
                //             )));
              },
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white),
              )),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isMapLoaded
          ? Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Please wait...")
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: Stack(
                      children: [
                        GoogleMap(
                          markers: Set<Marker>.of(<Marker>[
                            Marker(
                                markerId: MarkerId("1"),
                                draggable: true,
                                position: _center,
                                icon: BitmapDescriptor.defaultMarker,
                                infoWindow: const InfoWindow(title: "Location"))
                          ]),
                          onMapCreated: _onMapCreated,
                          onCameraMove: _onCameraMove,
                          initialCameraPosition:
                              CameraPosition(target: _center, zoom: 11.0),
                        ),
                        // Positioned(
                        //   top: 20.0,
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //     child: Container(
                        //         width: MediaQuery.of(context).size.width - 20,
                        //         height: 40.0,
                        //         color: Colors.white70,
                        //         child: Align(
                        //             alignment: Alignment.center,
                        //             child: Text(
                        //               widget.subService.name,
                        //             ))),
                        //   ),
                        // ),
                        // Positioned(
                        //   bottom: 150.0,
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //     child: Align(
                        //       alignment: Alignment.center,
                        //       child: Column(children: [
                        //         Container(
                        //             width: MediaQuery.of(context).size.width - 20,
                        //             height: 90.0,
                        //             decoration: BoxDecoration(
                        //                 color: Colors.white70,
                        //                 borderRadius: BorderRadius.circular(10)),
                        //             child: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   Text(
                        //                     widget.subService.name,
                        //                     style: TextStyle(
                        //                         color: Colors.black45,
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 18,
                        //                         letterSpacing: 1.2),
                        //                   ),
                        //                   SizedBox(
                        //                     height: 10,
                        //                   ),
                        //                   Text(
                        //                     "₦ ${widget.subService.cost}",
                        //                     style: TextStyle(
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 16,
                        //                         color: Colors.black54),
                        //                   ),
                        //                 ])),
                        //         SizedBox(
                        //           height: 10,
                        //         ),
                        //         Container(
                        //           height: 50.0,
                        //           width: double.infinity,
                        //           child: ElevatedButton(
                        //             onPressed: () {},
                        //             child: Text("Next"),
                        //             style: ElevatedButton.styleFrom(
                        //                 primary: Theme.of(context).primaryColor),
                        //           ),
                        //         )
                        //       ]),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children:[ 
                        Row(
                          children: [
                            Icon(Icons.home),
                            Expanded(child: Text(_address))


                          ],
                        ),

                        SizedBox(height: 10,),
                        
                        Container(
                          height: 90.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffE8E8E8)),
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffF8F8F8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(children: [
                                    Text("Selected Service:",style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.subService.name,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    Text("Service Cost:",style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "₦ ${widget.subService.cost}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ])
                                ]),
                          )),
                      ]
                    ),
                      
                  )
                ]),
              ),
            ),
    );
  }
}
