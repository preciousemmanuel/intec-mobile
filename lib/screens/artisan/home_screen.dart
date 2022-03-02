// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:collection';

// import 'dart:js';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/providers/artisan_request_provider.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:intechpro/screens/artisan/track_request_screen.dart';
import 'package:intechpro/widgets/address_detail.dart';
import 'package:intechpro/widgets/artisan_request_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseReference _dbRef;
  late StreamSubscription<DatabaseEvent> _requestSubscription;
  late StreamSubscription<DatabaseEvent> _newRequestSubscription;
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();

  bool _isLoading = false;
  bool _isnewRequest = false;
  Map<dynamic, dynamic> _newRequest = {};
  List _request = [];
  FirebaseException? _error;

  @override
  initState() {
    
    getUserServiceandSubService();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   Provider.of<ServiceProvider>(context, listen: false)
    //       .fetch_service_and_sub_by_userType(Provider.of<ProfileProvider>(context,listen:false).profile.userType);
    // });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    mainInit();
    newRequestInit();
    });

    super.initState();
  }

  void getUserServiceandSubService() async {
    Map<String, dynamic> response =
        await Provider.of<ServiceProvider>(context, listen: false)
            .fetch_service_and_sub_by_id(
                Provider.of<ProfileProvider>(context, listen: false)
                    .profile
                    .serviceId,
                Provider.of<ProfileProvider>(context, listen: false)
                    .profile
                    .subServiceId);
  }

  Future<void> newRequestInit() async {
    print("uiid");
    print(_request);
    print(Provider.of<User>(context, listen: false).uid);
    _dbRef = FirebaseDatabase.instance
        .ref("request/${Provider.of<User>(context, listen: false).uid}");
    //_dbRef.child("request/${Provider.of<User>(context,listen:false).uid}");

    _newRequestSubscription = _dbRef.onChildAdded.listen((DatabaseEvent event) {
      print("newRe####");
      print(event.snapshot.value);
      Map<dynamic, dynamic> values =
          event.snapshot.value as Map<dynamic, dynamic>;
      print("cont#v");
      print(values);
      if (values["requestStatus"] == 1) {
        setState(() {
          _isnewRequest = true;
          _newRequest = values;
        });
      }else{
        setState(() {
          _isnewRequest = false;
         // _newRequest = values;
        });
      }
      // List respList=values.entries.map(( key,entry){

      // }).toList();
    }, onError: (Object o) {
      final error = o as FirebaseException;
      print(error);
      setState(() {
        _isLoading = false;
        _error = error;
      });
    });
  }

//   Future<void> mainInit() async {
//     setState(() {
//       _isLoading = true;
//     });
//     print("heieo");
//     print(_request);

// // QuerySnapshot data = await  FirebaseFirestore.instance.collection("requests").where("artisans.",isEqualTo:serviceId )
// //        .where("subServiceId",isEqualTo:subServiceId )
// //         .where("active",isEqualTo:true )
// //        .get();

//     print(Provider.of<User>(context, listen: false).uid);
//     _dbRef = FirebaseDatabase.instance.ref("queue");
//     DataSnapshot event = await _dbRef
//      //.orderByValue()
//     //.orderByKey()
//         .orderByChild("artisan/uid")
        
//         .equalTo(Provider.of<User>(context, listen: false).uid)
//         .get();
//     //_dbRef.child("request/${Provider.of<User>(context,listen:false).uid}");

//     // _requestSubscription = _dbRef.onValue.listen((DatabaseEvent event) {
//     // DatabaseEvent event=await _dbRef.once();
//     print("poas##");
//     print(event.value);

//     Map<dynamic, dynamic> data = event.value as Map<dynamic, dynamic>;
//     // List respList=values.entries.map(( key,entry){

//     // }).toList();
//     //   print("mop3#o##");
//     //  print(data.values);
//     setState(() {
//       _isLoading = false;
//       _request = [];
//     });
//     if (event.value != null && data.values.isNotEmpty) {
//       print("her##");
//       List _newArray=[];
//       //  print(values["request"]);
//       setState(() {
//         // _isLoading = false;
//         _error = null;
        
//         //final reversMap=LinkedHashMap.fromEntries(data.values.toList().reversed);
//         data.values.forEach((value) {
//           print("postdat");
//           print(value);
//           // print(key);
//           _newArray.add(value);
//         });
//         // for (var value in event.snapshot.value) {
//         //   _request.add(value);
//         // }

//         print("list data#");
//         print(_newArray);
//         for (var i = _newArray.length-1; i >=0 ; i--) {
//           print("lko##");
//           print(i);
//           print(_newArray[i]);
//           _request.add(_newArray[i]);
//         }

//         print(_request);

//         // _request = event.snapshot.value;
//       });
//     }
//     // }, onError: (Object o) {
//     //   final error = o as FirebaseException;
//     //   print(error);
//     //   setState(() {
//     //     _isLoading = false;
//     //     _error = error;
//     //   });
//     // });
//   }

  Future<void> mainInit() async {
    setState(() {
      _isLoading = true;
    });
    print("uiid");
    print(_request);
    print(Provider.of<User>(context, listen: false).uid);
    _dbRef = FirebaseDatabase.instance
        .ref("request/${Provider.of<User>(context, listen: false).uid}");
    //_dbRef.child("request/${Provider.of<User>(context,listen:false).uid}");

    _requestSubscription = _dbRef.onValue.listen((DatabaseEvent event) {
      print("aboutDB#");
      print(event.snapshot.value);
      Map<dynamic, dynamic> values =
          event.snapshot.value as Map<dynamic, dynamic>;
      // List respList=values.entries.map(( key,entry){

      // }).toList();
      setState(() {
        _isLoading = false;
        _request = [];
      });
      if (values!= null && values.isNotEmpty) {
        print("her##");
        print(values["request"]);
        setState(() {
          _isLoading = false;
          _error = null;
          values.forEach((key, value) {
            print("postdat");
            print(value);
            print(key);
            _request.add(value);
          });
          // for (var value in event.snapshot.value) {
          //   _request.add(value);
          // }
          print("list data#");
          print(_request);

          // _request = event.snapshot.value;
        });
      }
    }, onError: (Object o) {
      final error = o as FirebaseException;
      print(error);
      setState(() {
        _isLoading = false;
        _error = error;
      });
    });
  }

  @override
  void dispose() {
    _requestSubscription.cancel();
    _newRequestSubscription.cancel();
    super.dispose();
  }

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    scaffoldkey.currentState!.showSnackBar(snackbar);
  }

  void _handleAcceptRequest(order_id) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Please wait..."),
            content: SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ),
          );
        });

    Map<String, dynamic> response =
        await context.read<ArtisanRequestProvider>().acceptRequest(order_id);
    Navigator.of(context).pop();
    setState(() {
      _isnewRequest=false;
    });
    if (response["status"]) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Request accepted successfully"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TrackRequestScreen(
                            request_id: order_id,
                            // userType: profile.userType,
                          ),
                        ),
                      );
                    },
                    child: Text("OK"))
              ],
            );
          });

//show alert and redirect to track status screen
    } else {
      ShowSnackBar(response["message"], false);
    }
  }

  Widget _buildNewRequestCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 130,
        decoration: BoxDecoration(
            color: Color(0xffEFE9FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Color(0xff602CD0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "A New Request Recieved",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.receipt,
                  color: Theme.of(context).primaryColor,
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (contextx) {
                          return StatefulBuilder(builder: (BuildContext context,
                              StateSetter setSheetState) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Text("New Request Recieved",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Client",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        Text("Status",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _newRequest["customer_name"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("PENDING")
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Service",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        Text("Price",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _newRequest["service_name"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                            currency.symbol +
                                                (_newRequest["userType"]==3 && _newRequest["requestStatus"]==1?_newRequest["amountForDistance"].toString() : _newRequest["amount"].toString()),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Divider(),

                                    AddressDetail(userType: _newRequest["userType"], startAddress: _newRequest["address"],destinationAdress: _newRequest["userType"]==3?_newRequest["address_destination"]:"",)
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.place,
                                    //       color: Theme.of(context).primaryColor,
                                    //     ),
                                    //     Expanded(
                                    //         child: Text(
                                    //       _newRequest["address"],
                                    //       style: TextStyle(
                                    //           color: Theme.of(context)
                                    //               .primaryColor),
                                    //     ))
                                    //   ],
                                    // ),
                                    ,
                                    Divider(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 45.0,
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                                          //   borderRadius: BorderRadius.circular(10)
                                          // ),
                                          // width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(contextx);
                                              setState(() {
                                                _isnewRequest = false;
                                              });

                                              //launch("tel://${_request["customer_phone"]}");
                                            },
                                            child: Row(children: [
                                              Icon(Icons.close),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Close",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ]),
                                            style: ElevatedButton.styleFrom(
                                                shape: StadiumBorder(),
                                                side: BorderSide(
                                                    color: Color(0xffEE4D4D)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 5),
                                                primary: Color(0xffEE4D4D)),
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
                                              Navigator.pop(contextx);
                                              _handleAcceptRequest(
                                                  _newRequest["order_id"]);
                                              //launch("tel://${_request["customer_phone"]}");
                                            },
                                            child: Row(children: [
                                              Icon(Icons.add),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Accept Request",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ]),
                                            style: ElevatedButton.styleFrom(
                                                shape: StadiumBorder(),
                                                side: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 5),
                                                primary: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                        });
                  },
                  child: Text("View Details",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _showExpiredAlert() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.red),
          child: TextButton(
            child: Text(
                "Please click to renew/ subscribe to enable you to get enlisted to customers.",
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pushNamed("/pay_subscription");
            },
          ),
        ),
      ),
      SizedBox(
        height: 10,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    print("countme#");
    print(_request.length);
    print(_request);
    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Align(
            alignment: Alignment.center,
            child: Text(
              "My Request",
              textAlign: TextAlign.center,
              style: TextStyle(color:Colors.black ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
             height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/background-front.jpg"),
                  fit: BoxFit.cover)

              //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
              ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                _isnewRequest ? _buildNewRequestCard() : Container(),
                SizedBox(
                  height: 30,
                ),
           
                (context.watch<ProfileProvider>().profile.userType == 4 &&
                        (!context
                                .watch<ProfileProvider>()
                                .profile
                                .hasSubscribed ||
                            context.watch<ProfileProvider>().profile.expired))
                    ? _showExpiredAlert()
                    : Container(),
                Text(
                  context.watch<ServiceProvider>().getService.name +
                      " / " +
                      context.watch<ServiceProvider>().getSubService.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "N/B: Please don't accept a request while still on another request. This might result to your account been blocked or freezed.",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      )
                    : _request.isEmpty
                        ? Column(
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Icon(
                              Icons.hourglass_empty,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "No Request Yet",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )
                          ],
                        )
                        : RefreshIndicator(
                            onRefresh: () {
                              return mainInit();
                            },
                            child: SizedBox(
                              height: 500,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: _request.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    Map<dynamic, dynamic> data = _request[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ArtisanRequestCard(
                                        request: data,
                                        onAcceptRequest: () {
                                          _handleAcceptRequest(data["order_id"]);
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ),
               
                //ArtisanRequestCard()
              ],
            ),
          ),
        ));
  }
}
