import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/providers/artisan_request_provider.dart';
import 'package:intechpro/providers/service_payment_provider.dart';
import 'package:intechpro/providers/user_location_provider.dart';
import 'package:intechpro/screens/home_artisan_screen.dart';
import 'package:intechpro/widgets/address_detail.dart';
import 'package:intechpro/widgets/payment_method_section.dart';
import 'package:intechpro/widgets/track_status.dart';
import 'package:location/location.dart';
import 'package:geocode/geocode.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:intechpro/widgets/address_search.dart';

import 'package:uuid/uuid.dart';

class TrackRequestScreen extends StatefulWidget {
  final request_id;
  const TrackRequestScreen({Key? key, required this.request_id})
      : super(key: key);

  @override
  _TrackRequestScreenState createState() => _TrackRequestScreenState();
}

class _TrackRequestScreenState extends State<TrackRequestScreen> {
  bool _isMapLoaded = false;
  var _request = null;
  FirebaseException? _error;
  bool initialized = false;
  late DatabaseReference _dbRef;
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();
  late StreamSubscription<DatabaseEvent> _orderSubscription;

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

  @override
  initState() {
    // init();
    super.initState();
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

  void showPinsOnMap() {
    print("here##hehe");
    print(Provider.of<UserLocationProvider>(context, listen: false)
        .getUserLocatiion["lat"]);
    Map<String, dynamic> location_artisan =
        Provider.of<UserLocationProvider>(context, listen: false)
            .getUserLocatiion;
    var reqLocation =
        LatLng(_request["location"]["lat"], _request["location"]["lon"]);
    _markers.add(Marker(
        markerId: MarkerId("1"),
        draggable: true,
        position: reqLocation,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Service Locaton")));

    if (_request["requestStatus"] > 1) {
      var artisanLocation =
          LatLng(location_artisan["lat"], location_artisan["lon"]);

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

    Map<String, dynamic> location_artisan =
        Provider.of<UserLocationProvider>(context, listen: false)
            .getUserLocatiion;

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        dotenv.env["GOOGLE_API_KEY"] ?? "",
        PointLatLng(_request["location"]["lat"], _request["location"]["lon"]),
        PointLatLng(location_artisan["lat"], location_artisan["lon"]),
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

  Widget _buildClientInfo(title, description) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Color(0xff52575C)),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          description,
          style: TextStyle(fontSize: 16, color: Color(0xff25282B)),
        )
      ],
    );
  }

  String _selectedCancelOption = "";
  String _selectedIndexOption = "";

  void _handleCancelRadioValueChanged(value) {
    print(value);
    setState(() => _selectedCancelOption = value);
  }

  Widget _buildCancelTile(title, index, setState) {
    print("on##");
    print(title);
    return ListTile(
        onTap: () {
          print("benny#");
          print(title);
          setState(() {
            _selectedIndexOption = index;
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

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _onClickIReach(order_id) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("INFO!"),
            content: Text("Have you arrived work/service location?"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Map<String, dynamic> response = await context
                      .read<ArtisanRequestProvider>()
                      .artisanIveArrived(order_id);

                  if (response["status"]) {
                    ShowSnackBar(response["message"], true);
                  } else {
                    ShowSnackBar(response["message"], false);
                  }
                },
                child: Text(
                  'YES',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          );
        });
  }

  Widget _buildArrivedButton() {
    if (_request["requestStatus"] > 2 &&
        (_request["hasArrived"] == null || !_request["hasArrived"])) {
      return Column(children: [
        Divider(),
        TextButton(
          onPressed: () {
            Provider.of<ArtisanRequestProvider>(context, listen: false)
                    .getSubmittingArrived
                ? () {}
                : _onClickIReach(_request["order_id"]);
          },
          child: Row(children: [
            Icon(
              Icons.place_outlined,
              color: Colors.red,
              size: 20,
            ),
            Text(
              context.watch<ArtisanRequestProvider>().getSubmittingArrived
                  ? "Please Wait..."
                  : "Have you arrived?",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ]),
        ),
      ]);
    }

    return Container();
  }

  Widget _buildMore() {
    if (_request["requestStatus"] == 3) {
      return Column(
        children: [
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
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
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: ListView(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "What do you want to do?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _buildCancelTile(
                                        "I have Completed client request, process my pay",
                                        "1",
                                        setSheetState),
                                    Divider(),
                                    _buildCancelTile(
                                        "Cancel, I could not complete request",
                                        "2",
                                        setSheetState),
                                    Divider(),
                                    _buildCancelTile(
                                        " I and client have misunderstanding",
                                        "3",
                                        setSheetState),

                                    Divider(),
                                    // CancelTile(title: "", selected: ""),
                                    context
                                            .watch<ArtisanRequestProvider>()
                                            .getSubmitting || context
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
                                                  if (_selectedIndexOption ==
                                                      "1") {
                                                    context
                                                        .read<
                                                            ArtisanRequestProvider>()
                                                        .confirmRequestComplete(
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
                                                                content: Text(_request[
                                                                            "paymentMode"] <
                                                                        3
                                                                    ? "Pay will be transfered to your wallet soon as customer confirms."
                                                                    : "Client will pay you the required fee."),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.of(context).pushAndRemoveUntil(
                                                                          MaterialPageRoute(
                                                                              builder: (BuildContext context) =>
                                                                                  HomeArtisanScreen()),
                                                                          (Route<dynamic> route) =>
                                                                              false);
                                                                    },
                                                                    child: Text(
                                                                      'OK',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).primaryColor),
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
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'OK',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      }
                                                    });
                                                  } else {
                                                    context
                                                        .read<
                                                            ServicePaymentProvider>()
                                                        .cancelRequest(
                                                            _request[
                                                                "order_id"],
                                                            _selectedCancelOption,
                                                            "artisan")
                                                        .then((value) {
                                                      if (value["status"]) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Message"),
                                                                content: Text(
                                                                    "Request cancelled successfully"),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      // Navigator.of(context).pushAndRemoveUntil(
                                                                      //     MaterialPageRoute(
                                                                      //         builder: (BuildContext context) =>
                                                                      //             HomeScreen()),
                                                                      //     (Route<dynamic> route) =>
                                                                      //         false);
                                                                    },
                                                                    child: Text(
                                                                      'OK',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).primaryColor),
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
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'OK',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      }
                                                    });
                                                  }
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
                      Icon(
                        Icons.more_sharp,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "More",
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ]),
                    style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(color: Theme.of(context).accentColor),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        primary: Colors.white),
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
                      launch("tel://${_request["customer_phone"]}");
                    },
                    child: Row(children: [
                      Icon(Icons.call),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Call Client",
                        style: TextStyle(color: Colors.white),
                      ),
                    ]),
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        primary: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          )
        ],
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Track Request "),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
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
            : Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildClientInfo("Client", _request["customer_name"]),
                          Text(" | "),
                          _buildClientInfo("Service", _request["service_name"]),
                          Text(" | "),
                          _buildClientInfo(
                              "Amount",
                              currency.symbol +
                                  (_request["userType"] == 3 &&
                                          _request["requestStatus"] <= 3
                                      ? _request["amountForDistance"].toString()
                                      : _request["amount"].toString())),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PaymentMethodSection(
                              paymentMethod: _request["paymentMode"]??1),
                          Text(" | "),
                          _request["userType"] == 3
                              ? _buildClientInfo("No. of Trips",
                                  _request["selected_trip"].toString())
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  _request["userType"] == 3
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: _buildClientInfo("No. of Trips",
                                  _request["selected_trip"].toString())),
                        )
                      : Container(),
                  Divider(),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: AddressDetail(
                        userType: _request["userType"],
                        startAddress: _request["address"],
                        destinationAdress: _request["userType"] == 3
                            ? _request["address_destination"]
                            : "",
                      )),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(
                          height: 10,
                        ),
                        TrackStatus(
                          title: _request["requestStatus"] > 2
                              ? "Confirmed by Customer"
                              : "Waiting for Customer Payment Confirmation",
                          status: _request["requestStatus"] > 2 ? true : false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TrackStatus(
                          title: _request["requestStatus"] > 3
                              ? "Request Completed"
                              : "Request Not Completed",
                          status: _request["requestStatus"] > 3 ? true : false,
                        )
                      ],
                    ),
                  ),
                  _buildArrivedButton(),
                  _buildMore()
                ],
              ),
      )),
    );
  }
}
