import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intechpro/model/request_model.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/providers/customer_request_provider.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/screens/payment_service_screen.dart';
import 'package:intechpro/screens/request_status_screen.dart';
import 'package:intechpro/widgets/request_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intechpro/widgets/drawer.dart';
// import 'package:intechpro/widgets/address_search.dart';

class CustomerRequestsScreen extends StatefulWidget {
  CustomerRequestsScreen({Key? key});

  @override
  _CustomerRequestsScreenState createState() => _CustomerRequestsScreenState();
}

class _CustomerRequestsScreenState extends State<CustomerRequestsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool initialized = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<CustomerRequestProvider>(context, listen: false)
          .fetch_requests();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onHandleTap(Request request) {
    //also check if not supplier then redirect to suppliers with the call phone number 
    if (request.requestStatus>=1 && request.requestStatus<=2) {
      print("fort#");
      print(LatLng(request.customer_location["lat"], request.customer_location["lon"]));
      Service service=Service(name: "",userType: request.userType,uid: request.parent_service_id,visible: true);
      SubService subservice=SubService(name: request.service_name,uid: request.service_id,visible: true,hasTask:false,cost:request.amount.toInt(),serviceId: request.parent_service_id);
      //SubService subservice=SubService(name: request.userType==2 && !request.service_name.contains("Request Assessment") ?"":request.service_name,uid: request.service_id,visible: true,hasTask: request.userType==2 && !request.service_name.contains("Request Assessment")?true:false,cost:int.parse(request.amount.toString()),serviceId: request.parent_service_id);
     Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PaymentServiceScreen(
                    destinationAddress: request.destination_address,
                    requestId: request.uid,
                    subservice: subservice,
                    parentService: service,
                    location: LatLng(request.customer_location["lat"], request.customer_location["lon"]),
                    address: request.request_address)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => RequestStatusScreen(request_id: request.uid)),);
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()),
                (Route<dynamic> route) => false);
          },
        ),
        key: _key,
        appBar: AppBar(
          title: Text("My Requests "),
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("assets/images/backgound.jpg"),
                    fit: BoxFit.cover)

                //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
                ),
            child: context.watch<CustomerRequestProvider>().getLoading
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
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      Container(),
                      SizedBox(
                        height: 40,
                      ),
                   context
                              .watch<CustomerRequestProvider>()
                              .getRequests
                              .length==0? Column(
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
                              "You havent requested for a service.",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )
                          ],
                        ) :   Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemCount: context
                              .watch<CustomerRequestProvider>()
                              .getRequests
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            Request request = context
                                .watch<CustomerRequestProvider>()
                                .getRequests[index];

                            return RequestCard(
                                onTap: () => _onHandleTap(request),
                                request: request);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
          ),
        ));
  }
}
