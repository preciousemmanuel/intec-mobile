import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intechpro/model/address_suggestion.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/widgets/address_search.dart';
// import 'package:intechpro/widgets/address_search.dart';
import 'package:location/location.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class RequestServiceScreen extends StatefulWidget {
  SubService subService;

  RequestServiceScreen({Key? key, required this.subService});

  @override
  _RequestServiceScreenState createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  final _textcontroller = TextEditingController();
  bool _isMapLoaded = false;
  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';

  double latitude = 0.001;
  double longitude = 0.999;
  LocationData? currentLocation;
  String address = "";
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  static LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng _lastMapPosition = _center;

  @override
  initState() {
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
      LocationData? location = value;
      print(location!.latitude);
      setState(() {
        _isMapLoaded = false;
        print("du###vf");
        _center = LatLng(location.latitude, location.longitude);
      });

      // setState(() {
      //   _center = const LatLng(location.latitude==null?6.000:location.latitude, -122.677433);
      // });

      // _getAddress(location.latitude, location.longitude).then((value) {
      //   print("uyDF#");
      //   print(value);
      //   setState(() {
      //     currentLocation = location;
      //     address = value;
      //     _center = LatLng(location.latitude, location.longitude);
      //   });
      // }).catchError((e) {
      //   print("preee##");
      //   print(e);
      // });
    });
  }

  Future<String> _getAddress(double? lat, double? lang) async {
    print("add##");
    print(lat);
    if (lat == null || lang == null) return "";
    print("pass##");
    GeoCode geoCode = GeoCode();
    Address address =
        await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    print("opi##");
    print(address);
    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
  }

  Future<LocationData?> _getLocationData() async {
    Location location = new Location();
    LocationData _locationData;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
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
        title: Text("Choose Location"),
        actions: [
          IconButton(
              onPressed: () async {
                final sessionToken = Uuid().v4();
                final AddressSuggestion? result = await showSearch(
                    context: context, delegate: AddressSearch(sessionToken));

                print(result);
              },
              icon: const Icon(Icons.search)),
          TextButton(
              onPressed: () {},
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
          : Stack(
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
                Positioned(
                  top: 20.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 40.0,
                        color: Colors.white70,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.subService.name,
                            ))),
                  ),
                ),
              ],
            ),
    );
  }
}
