import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/model/service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intechpro/model/user.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:intechpro/screens/home_artisan_screen.dart';
import 'package:intechpro/screens/not_verified_screen.dart';
import 'package:intechpro/screens/notification.dart';
import 'package:intechpro/screens/sub_service_screen.dart';
import 'package:intechpro/widgets/drawer.dart';
import 'package:intechpro/widgets/service_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  var user = FirebaseAuth.instance.currentUser;
  late FirebaseMessaging messaging;

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      print("token");

      print(value);

      userRef.doc(user!.uid).update({"fcmToken": value});
    });
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      checkUserType();
    });
  }

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  void checkUserType() async {
    Map<String, dynamic> response =
        await context.read<ProfileProvider>().fetch_user();
    if (response["status"]) {
      Profile user = response["user"];
      print("ysue###");
      print(user.userType);
     
      if (user.userType > 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => HomeArtisanScreen()),
            (Route<dynamic> route) => false);
      } else {
        Provider.of<ServiceProvider>(context, listen: false).fetch_services();
      }
    }
  }

  void onhandleTap(Service service) {
    print("sher@##");
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SubServiceScreen(service: service)));
    print(service.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Color(0xffF0F0F0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: context.watch<ProfileProvider>().loading
              ? () {}
              : () {
                  _key.currentState!.openDrawer();
                },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "IntecPRO",
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: AppDrawer(
        displayName: context.watch<ProfileProvider>().profile.name,
      ),
      body: SingleChildScrollView(
        child: context.watch<ProfileProvider>().loading
                ? Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Please wait...")
                      ],
                    ),
                  ): Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/backgound.jpg"),
                  fit: BoxFit.cover)

              //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
              ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 22.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25.0,
                                color: Theme.of(context).accentColor),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: Text(
                              context.watch<ProfileProvider>().profile.name,
                              // context.watch<User>().displayName,
                              style: TextStyle(
                                  color: Color(0xff4E4D4D), fontSize: 20.0),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "What do you want to do:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      context.watch<ServiceProvider>().getLoading
                          ? Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Loading Services...")
                                ],
                              ),
                            )
                          : Expanded(
                              // height: 100.0,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 8.0 / 9.0),
                                  itemCount: context
                                      .watch<ServiceProvider>()
                                      .getServices
                                      .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Service service = context
                                        .watch<ServiceProvider>()
                                        .getServices[index];
                                    return ServiceCard(
                                        onTap: () => onhandleTap(service),
                                        service: service);
                                  },
                                  // crossAxisCount: 3,
                                ),
                              ),
                            )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
