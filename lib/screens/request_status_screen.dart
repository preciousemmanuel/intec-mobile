import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intechpro/model/currency.dart';

import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/providers/service_payment_provider.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/widgets/cancel_tile.dart';
import 'package:intechpro/widgets/payment_method_section.dart';
import 'package:intechpro/widgets/track_status.dart';
import 'package:provider/provider.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:intechpro/widgets/drawer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:intechpro/widgets/address_search.dart';
import 'package:location/location.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestStatusScreen extends StatefulWidget {
  final request_id;
  bool? newRequest = false;

  RequestStatusScreen({Key? key, required this.request_id, this.newRequest});

  @override
  _RequestStatusScreenState createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  final _textcontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _isMapLoaded = false;
  var _request = null;
  FirebaseException? _error;
  bool initialized = false;
  late DatabaseReference _dbRef;
  late StreamSubscription<DatabaseEvent> _orderSubscription;

  double latitude = 0.001;
  double longitude = 0.999;

  String address = "";
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();
// for my drawn routes on the map

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

// for my custom marker pins
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;

  static LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng _artisanLocation = LatLng(45.521563, -122.677433);
  LatLng _lastMapPosition = _center;

  // as it moves
  LocationData? currentLocation;
// a reference to the destination location
  LocationData? destinationLocation;
// wrapper around the location API
  Location? location;

  String _selectedCancelOption = "";

  void _handleCancelRadioValueChanged(value) {
    print(value);
    setState(() => _selectedCancelOption = value);
  }

  @override
  initState() {
    // init();
    super.initState();
    // set custom marker pins
    setSourceAndDestinationIcons();
    init();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2), 'assets/images/pin.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/destination.png');
  }

  Future<void> init() async {
    _dbRef = FirebaseDatabase.instance.ref("queue/${widget.request_id}");
    // _dbRef.child("queue").child("${widget.request_id}");
    print("her###");
    print("queue/${widget.request_id}");
    print(_dbRef.get());
    _orderSubscription = _dbRef.onValue.listen((DatabaseEvent event) {
      print("new###db");
      print(event.snapshot.value);
      setState(() {
        _error = null;
        _request = event.snapshot.value;
        print("to##");
        print(_request);
      });
    }, onError: (Object o) {
      final error = o as FirebaseException;
      print(error);
      setState(() {
        _error = error;
      });
    });
  }

  @override
  void dispose() {
    _orderSubscription.cancel();
    super.dispose();
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _center = position.target;
    });
  }

  Widget _buildArtisanView() {
    if (_request["requestStatus"] == 0) {
      return Column(children: [
        SizedBox(
          height: 10,
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            )),
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TrackStatus(
              title: "Cancelled",
              status: false,
            )),
      ]);
    } else if (_request["requestStatus"] == 1) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
            Text(
              _request["userType"] == 2
                  ? "Searching for the best Artisan for you. Please wait..."
                  : _request["userType"] == 3
                      ? "Searching for the best Truck Driver for you. Please wait..."
                      : "Searching for the best Supplier for you. Please wait...",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            )
          ],
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TrackStatus(
                title: "Request Accepted",
                status: true,
              )),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TrackStatus(
                title: _request["artisan"]["userType"] == 2
                    ? 'Artisan on the way to the location'
                    : _request["artisan"]["userType"] == 3
                        ? "Truck Driver On the way"
                        : "Supplier On the way",
                status: true,
              )),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TrackStatus(
                title: _request["requestStatus"] > 3
                    ? "Request Completed"
                    : "Request Not Completed",
                status: _request["requestStatus"] > 3 ? true : false,
              )),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Artisan Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: Image.asset(
                    "assets/images/user.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor),
                    ),
                    Text(_request["artisan"]["name"])
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Text(
                      "Phone",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor),
                    ),
                    Text(_request["artisan"]["phone"])
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }
  }

  void showPinsOnMap() {
    print("here##hehe");
    var reqLocation =
        LatLng(_request["location"]["lat"], _request["location"]["lon"]);
    _markers.add(Marker(
        markerId: MarkerId("1"),
        draggable: true,
        position: reqLocation,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Service Locaton")));

    if (_request["requestStatus"] > 1) {
      var artisanLocation = LatLng(_request['artisan']["location"]["latitude"],
          _request['artisan']["location"]["longitude"]);

      _markers.add(Marker(
          markerId: MarkerId("2"),
          draggable: true,
          position: artisanLocation,
          icon: destinationIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: "Artisan Locaton")));

      // set the route lines on the map from source to destination
      // for more info follow this tutorial
      setPolylines();
    }
  }

  void setPolylines() async {
    print("horur#");

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        dotenv.env["GOOGLE_API_KEY"] ?? "",
        PointLatLng(_request["location"]["lat"], _request["location"]["lon"]),
        PointLatLng(_request['artisan']["location"]["latitude"],
            _request['artisan']["location"]["longitude"]),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      print("jor##d");
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      print(polylineCoordinates);
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

  Widget _buildCancelTile(title, index, setState) {
    print("on##");
    print(title);
    return ListTile(
        onTap: () {
        
          print(title);
          setState(() {
            _selectedCancelOption = title;
          });
        },
        title: Text(
          title,
        ),
        leading: Radio(
            value: title,
            groupValue: _selectedCancelOption,
            onChanged: _handleCancelRadioValueChanged));
  }

  Widget _buildAdress() {
    if (_request["userType"] == 3) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Pickup Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.home,
              color: Theme.of(context).accentColor,
            ),
            Expanded(child: Text(_request["address"])),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text("Destination Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.place,
              color: Theme.of(context).accentColor,
            ),
            Expanded(child: Text(_request["address_destination"])),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.car_rental,
              color: Theme.of(context).accentColor,
            ),
            Expanded(
                child: Text(
                    "No. of Trips: " + _request["selected_trip"].toString())),
          ],
        )
      ]);
    }
    return Column(children: [
      Text("Location",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.location_city,
            color: Theme.of(context).accentColor,
          ),
          Expanded(child: Text(_request["address"])),
        ],
      )
    ]);
  }

  Widget _buildConfirmDeclinePay() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(top: 0),
            // height: 140,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ]),
            child: Column(
              children: [
                Text(
                    "Request is marked complete and payment request has been initiated;"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 45.0,
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                      //   borderRadius: BorderRadius.circular(10)
                      // ),
                      // width: double.infinity,
                      child: context
                                            .watch<ServicePaymentProvider>()
                                            .isSubmitting
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Theme.of(context)
                                                            .primaryColor)),
                                          ): ElevatedButton(
                        onPressed: () {
                            context
                                                      .read<
                                                          ServicePaymentProvider>()
                                                      .approveArtisanPayment(
                                                        _request["order_id"],
                                                        
                                                      )
                                                      .then((value) {
                                                    if (value["status"]) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Message"),
                                                              content: Text(
                                                                    "You have successfully approved the payment request."),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    // Navigator.of(context).pushAndRemoveUntil(
                                                                    //     MaterialPageRoute(
                                                                    //         builder: (BuildContext context) =>
                                                                    //             HomeArtisanScreen()),
                                                                    //     (Route<dynamic>
                                                                    //             route) =>
                                                                    //         false);
                                                                  },
                                                                  child: Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    } else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Message"),
                                                              content: Text(value[
                                                                  "message"]),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    }
                                                  });
                                                
                        },
                        child: Row(children: [
                          Icon(Icons.check),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Approve ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            primary: Theme.of(context).primaryColor),
                      ),
                    ),
                    Container(
                      height: 45.0,
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                      //   borderRadius: BorderRadius.circular(10)
                      // ),
                      // width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                           showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter setSheetState) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: ListView(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Why do you want to decline payment?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _buildCancelTile(
                                        "Task isnt completed",
                                        "1",
                                        setSheetState),
                                    Divider(),
                                    _buildCancelTile(
                                        "Worker is unavailable",
                                        "2",
                                        setSheetState),
                                    Divider(),
                                   
                                    // CancelTile(title: "", selected: ""),
                                    context
                                            .watch<ServicePaymentProvider>()
                                            .isSubmitting
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Theme.of(context)
                                                            .primaryColor)),
                                          )
                                        : Container(
                                            height: 40.0,
                                            // decoration: BoxDecoration(
                                            //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                                            //   borderRadius: BorderRadius.circular(10)
                                            // ),
                                            // width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_selectedCancelOption !=
                                                    "") {
                                                  
                                                  context
                                                      .read<
                                                          ServicePaymentProvider>()
                                                      .denyArtisanPayment(
                                                        _request["order_id"],
                                                        _selectedCancelOption
                                                      )
                                                      .then((value) {
                                                    if (value["status"]) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Message"),
                                                              content: Text(
                                                                    "You have successfully denied the payment request."),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    // Navigator.of(context).pushAndRemoveUntil(
                                                                    //     MaterialPageRoute(
                                                                    //         builder: (BuildContext context) =>
                                                                    //             HomeArtisanScreen()),
                                                                    //     (Route<dynamic>
                                                                    //             route) =>
                                                                    //         false);
                                                                  },
                                                                  child: Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    } else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Message"),
                                                              content: Text(value[
                                                                  "message"]),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    }
                                                  });
                                                
                                                } else {}
                                              },
                                              child: Text(
                                                "Continue ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: StadiumBorder(),
                                                  side: BorderSide(
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  primary: Theme.of(context)
                                                      .accentColor),
                                            ),
                                          )
                                  ],
                                ),
                              );
                            });
                          });
                   
                        },
                        child: Row(children: [
                          Icon(Icons.cancel),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Decline ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            side: BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            primary: Colors.red),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          SizedBox(height: 20,)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text("Track Request "),
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _key.currentState!.openDrawer();
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: AppDrawer(
          displayName: context.watch<ProfileProvider>().profile.name,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            //physics: NeverScrollableScrollPhysics(),
            child: _request == null
                ? Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text("Please wait...")
                      ],
                    ),
                  )
                : Column(children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: GoogleMap(
                        markers: _markers,
                        polylines: _polylines,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);

                          showPinsOnMap();
                        },
                        // onCameraMove: _onCameraMove,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(_request["location"]["lat"],
                                _request["location"]["lon"]),
                            zoom: 11.0),
                      ),
                    ),
                    _request["requestStatus"] == 4? _buildConfirmDeclinePay():Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0),
                        // height: 140,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.work_rounded,
                                  color: Theme.of(context).accentColor,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    _request["service_name"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildAdress(),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(Icons.money,
                                    color: Theme.of(context).accentColor),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "${currency.symbol} ${_request["amount"]}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                            _request["requestStatus"] > 2
                                ? PaymentMethodSection(
                                    paymentMethod: _request["paymentMethod"])
                                : Container()
                          ],
                        ),
                      ),
                    ),
                   
                    _buildArtisanView(),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: _request["requestStatus"] == 1
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          _request["requestStatus"] == 1
                              ? Container(
                                  height: 45.0,
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                                  //   borderRadius: BorderRadius.circular(10)
                                  // ),
                                  // width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setSheetState) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: ListView(
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Text(
                                                      "Why Do you want to cancel request?",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    _buildCancelTile(
                                                        "Could not find Artisan",
                                                        "1",
                                                        setSheetState),
                                                    Divider(),
                                                    _buildCancelTile(
                                                        "Artisan asked me to cancel",
                                                        "2",
                                                        setSheetState),

                                                    Divider(),
                                                    // CancelTile(title: "", selected: ""),
                                                    context
                                                            .watch<
                                                                ServicePaymentProvider>()
                                                            .isSubmitting
                                                        ? Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: CircularProgressIndicator(
                                                                valueColor: AlwaysStoppedAnimation<
                                                                    Color>(Theme.of(
                                                                        context)
                                                                    .primaryColor)),
                                                          )
                                                        : Container(
                                                            height: 40.0,
                                                            // decoration: BoxDecoration(
                                                            //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                                                            //   borderRadius: BorderRadius.circular(10)
                                                            // ),
                                                            // width: double.infinity,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                if (_selectedCancelOption !=
                                                                    "") {
                                                                  context
                                                                      .read<
                                                                          ServicePaymentProvider>()
                                                                      .cancelRequest(
                                                                          _request[
                                                                              "order_id"],
                                                                          _selectedCancelOption,
                                                                          "customer")
                                                                      .then(
                                                                          (value) {
                                                                    if (value[
                                                                        "status"]) {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              title: Text("Message"),
                                                                              content: Text("Request cancelled successfully"),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()), (Route<dynamic> route) => false);
                                                                                  },
                                                                                  child: Text(
                                                                                    'OK',
                                                                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            );
                                                                          });
                                                                    } else {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              title: Text("Message"),
                                                                              content: Text(value["message"]),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'OK',
                                                                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            );
                                                                          });
                                                                    }
                                                                  });
                                                                } else {}
                                                              },
                                                              child: Text(
                                                                "Continue ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              style: ElevatedButton.styleFrom(
                                                                  shape:
                                                                      StadiumBorder(),
                                                                  side: BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              15,
                                                                          vertical:
                                                                              5),
                                                                  primary: Theme.of(
                                                                          context)
                                                                      .accentColor),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              );
                                            });
                                          });
                                    },
                                    child: Text(
                                      "Cancel Request ",
                                      style:
                                          TextStyle(color: Color(0xffEE4D4D)),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        shape: StadiumBorder(),
                                        side: BorderSide(
                                            color: Color(0xffEE4D4D)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        primary: Colors.white),
                                  ),
                                )
                              : Container(
                                  // height: 45.0,
                                  // // decoration: BoxDecoration(
                                  // //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                                  // //   borderRadius: BorderRadius.circular(10)
                                  // // ),
                                  // // width: double.infinity,
                                  // child: OutlinedButton(
                                  //   onPressed: () {},
                                  //   child: Row(
                                  //     children: [Text(
                                  //       "More ",
                                  //       style: TextStyle(
                                  //           color:
                                  //               Theme.of(context).primaryColor),
                                  //     ),
                                  //     Icon(Icons.more,color: Theme.of(context).primaryColor,)
                                  //     ]
                                  //   ),
                                  //   style: OutlinedButton.styleFrom(
                                  //       shape: StadiumBorder(),
                                  //       side: BorderSide(
                                  //           color:
                                  //               Theme.of(context).primaryColor),
                                  //       padding: EdgeInsets.symmetric(
                                  //           horizontal: 15, vertical: 5),
                                  //       primary: Colors.white),
                                  // ),
                                  ),
                          _request["requestStatus"] == 3
                              ? Container(
                                  height: 45.0,
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                                  //   borderRadius: BorderRadius.circular(10)
                                  // ),
                                  // width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      launch(
                                          "tel://${_request["artisan"]["phone"]}");
                                    },
                                    child: Row(children: [
                                      Icon(Icons.call),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Call ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ]),
                                    style: ElevatedButton.styleFrom(
                                        shape: StadiumBorder(),
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        primary:
                                            Theme.of(context).primaryColor),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ]),
          ),
        ));
  }
}
