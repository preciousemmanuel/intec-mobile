import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intechpro/model/address_suggestion.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/model/task.dart';
import 'package:intechpro/providers/service_payment_provider.dart';
import 'package:intechpro/screens/payment_service_screen.dart';
import 'package:intechpro/widgets/address_search.dart';
// import 'package:intechpro/widgets/address_search.dart';
import 'package:location/location.dart' as LocationData;
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:provider/provider.dart';

class RequestServiceScreen extends StatefulWidget {
  SubService subService;
  Service? parentService;
  Task? task;

  RequestServiceScreen(
      {Key? key, required this.subService, this.parentService, this.task});

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
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();

  double latitude = 0.001;
  double longitude = 0.999;
  LocationData.LocationData? currentLocation;
  String _address = "";
  String _addressDestination = "";
  Completer<GoogleMapController> _controller = Completer();
  // final Set<Marker> _markers = {};
//  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Set<Marker> _markers = Set<Marker>();
  late LatLng _center;
  Map<String, dynamic>? _startLocationMap;

  late LatLng _destination=LatLng(0.0001, 0.001);
  Map<String, dynamic>? _destinationMap={};
  bool _isPickupChosen = true;
  // LatLng _lastMapPosition = _center;

  @override
  initState() {
    print("googleKeuy");
    print(dotenv.env["GOOGLE_API_KEY"] ?? "");
    googGeocoding = GoogleGeocoding(dotenv.env["GOOGLE_API_KEY"] ?? "");
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
          _center =
              LatLng(location.latitude ?? 0.00, location.longitude ?? 0.00);
          _startLocationMap = {
            "lat": location.latitude,
            "long": location.longitude
          };
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

    var response = await googGeocoding.geocoding.get(address, []);
    if (response != null && response.results != null) {
      print(response.results![0].geometry!.location!.lat ?? 0);
      print(response.results![0].geometry!.location!.lng ?? 0);

      CameraPosition cPosition = CameraPosition(
          zoom: 11.0,
          target: LatLng(response.results![0].geometry!.location!.lat ?? 0.00,
              response.results![0].geometry!.location!.lng ?? 0.00));

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

      if (_isPickupChosen) {
        setState(() {
          _markers.removeWhere((m) => m.markerId.value == "newMarker");
          _markers.add(Marker(
              markerId: MarkerId("newMarker"),
              position: LatLng(
                  response.results![0].geometry!.location!.lat ?? 0.00,
                  response.results![0].geometry!.location!.lng ?? 0.00),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: address)));
          _address = address;

          _center = LatLng(response.results![0].geometry!.location!.lat ?? 0.00,
              response.results![0].geometry!.location!.lng ?? 0.00);
          _startLocationMap = {
            "lat": response.results![0].geometry!.location!.lat,
            "long": response.results![0].geometry!.location!.lng
          };
          print("hoesr#");
          print(_center);
          print(_startLocationMap);
        });
      } else {
        setState(() {
          _markers.removeWhere((m) => m.markerId.value == "newMarker");
          _markers.add(Marker(
              markerId: MarkerId("destMarker"),
              position: LatLng(
                  response.results![0].geometry!.location!.lat ?? 0.00,
                  response.results![0].geometry!.location!.lng ?? 0.00),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: address)));
          _addressDestination = address;

          _destination = LatLng(
              response.results![0].geometry!.location!.lat ?? 0.00,
              response.results![0].geometry!.location!.lng ?? 0.00);
          _destinationMap = {
            "lat": response.results![0].geometry!.location!.lat,
            "long": response.results![0].geometry!.location!.lng
          };

          print("fhkoo##");
          print(_destinationMap);
          print(_destination);
        });
      }
    }
  }

  Future<String> _getAddress(double? lat, double? lang) async {
    print("add##");
    print(lat);
    if (lat == null || lang == null) return "";
    print("pass##");
    final LatLon coord = LatLon(lat, lang);
    print(coord);
    var result = await googGeocoding.geocoding.getReverse(coord);
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
    _markers.add(Marker(
        markerId: MarkerId("newMarker"),
        draggable: true,
        position: _center,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Location")));
  }

  void _handleRequestArtisan() async {
    print("here");
    String taskname = widget.subService.hasTask
        ? widget.task!.cost == 0
            ? widget.subService.name + " Service; Request Assessment"
            : widget.task!.name
        : widget.subService.name;
    print("hre locatR##");
    print(_center.latitude);
    print(_center.latitude);
    print(_center.longitude);
    print(_destination.latitude);
    print(_destination.longitude);

var amount=widget.subService.hasTask
        ? widget.task!.cost == 0
            ? widget.subService.cost 
            : widget.task!.cost
        : widget.subService.cost;

    Map<String, dynamic> response =
        await context.read<ServicePaymentProvider>().handleRequestArtisan(
            taskname,
            1,
            //  _selected_trip,
            widget.subService.uid,
            widget.parentService!.uid,
            widget.parentService!.userType,
            amount,
            _startLocationMap?["lat"],
            _startLocationMap?["long"],
            _address,
            1,
            _addressDestination,
            _destinationMap?["lat"],
            _destinationMap?["long"]);

    if (response["status"]) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => widget.subService.hasTask
                ? PaymentServiceScreen(
                    requestId: response["request_id"],
                    subservice: widget.subService,
                    task: widget.task,
                    parentService: widget.parentService,
                    location: _center,
                    destinationAddress: _addressDestination,
                    address: _address)
                : PaymentServiceScreen(
                    destinationAddress: _addressDestination,
                    requestId: response["request_id"],
                    subservice: widget.subService,
                    parentService: widget.parentService,
                    location: _center,
                    address: _address)),
      );
    } else {
      ShowSnackBar(response["message"], false);
    }
  }

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  handleShowSearchScreen(bool ispickuptype) async {
    if (widget.parentService!.userType == 3) {
      setState(() {
        _isPickupChosen = ispickuptype;
      });
    }
    final sessionToken = Uuid().v4();
    final AddressSuggestion? result = await showSearch(
        context: context, delegate: AddressSearch(sessionToken));
    print("addressSe#del");
    print(result!.description);
    _getCoordinates(result.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          title: Text(
            widget.parentService!.userType == 3
                ? "Choose Destinatination"
                : "Choose Work Location",
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  handleShowSearchScreen(true);
                },
                icon: const Icon(Icons.search)),
            context.watch<ServicePaymentProvider>().isSubmitting
                ? Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Request Info"),
                              content: Text("Do you want to continue?"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    )),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _handleRequestArtisan();

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (_) => widget.subService.hasTask?PaymentServiceScreen(
                                    //           subservice: widget.subService,
                                    //           task: widget.task,
                                    //           parentService: widget.parentService,
                                    //           location: _center,
                                    //           address: _address) : PaymentServiceScreen(
                                    //           subservice: widget.subService,
                                    //           parentService: widget.parentService,
                                    //           location: _center,
                                    //           address: _address)));
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
                child: Stack(
                  children: [
                    GoogleMap(
                      markers: _markers,
                      // myLocationButtonEnabled: true,
                      // markers: Set<Marker>.of(<Marker>[
                      //   Marker(
                      //       markerId: MarkerId("newMarker"),
                      //       draggable: true,
                      //       position: _center,
                      //       icon: BitmapDescriptor.defaultMarker,
                      //       infoWindow: const InfoWindow(title: "Location"))
                      // ]),
                      onMapCreated: _onMapCreated,
                      onCameraMove: _onCameraMove,
                      initialCameraPosition:
                          CameraPosition(target: _center, zoom: 11.0),
                    ),
                    Positioned(
                      top: 20.0,
                      child: widget.parentService?.userType == 3
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      handleShowSearchScreen(true);
                                    },
                                    child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.home,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            Expanded(
                                                child: Text(
                                              _address == ""
                                                  ? "Choose Pick Address"
                                                  : _address,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                            Icon(
                                              Icons.search,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      handleShowSearchScreen(false);
                                    },
                                    child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                width: 2)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.place,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            Expanded(
                                                child: Text(
                                              _addressDestination == ""
                                                  ? "Choose Destination Address"
                                                  : _addressDestination,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                            Icon(
                                              Icons.search,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 40.0,
                                  color: Colors.white70,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Icon(Icons.home),
                                        Expanded(child: Text(_address))
                                      ],
                                    ),
                                  )),
                            ),
                    ),
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
              ));
  }
}
