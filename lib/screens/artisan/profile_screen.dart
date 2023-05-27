

// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/rendering.dart';
import 'package:intechpro/providers/customer_wallet_provider.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/screens/image_upload_screen.dart';
import 'package:intechpro/screens/update_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config.dart';
import 'package:intechpro/model/currency.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _activeStatus = false;


 initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<CustomerWalletProvider>(context, listen: false)
          .fetch_wallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () =>  Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ImageUploadScreen(
                                userType:context.watch<ProfileProvider>().profile.userType,
                                fromNav: "Profile",
                              ),
                            ),
                          ),
                        child: context.watch<ProfileProvider>().profile.imageUrl==""?  Image.asset(
                          "assets/images/user.png",
                          width: 70,
                          height: 70,
                        ):
                        CircleAvatar(
                          backgroundImage: AssetImage("assets/images/user.png"),
                          radius: 50,
                          
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(context.watch<ProfileProvider>().profile.imageUrl!),),
                        )
                       
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              context.watch<ProfileProvider>().profile.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => UpdateProfileScreen()),
                                );
                              },
                              child: Text(
                                "Update Profile",
                                style: TextStyle(color: Colors.black45),
                              ))
                        ],
                      ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      Row(
                        children: [
                         context.watch<ProfileProvider>().profile.active? Text("Active",style: TextStyle(color: Colors.green),): Text("Inactive",style: TextStyle(color: Colors.red)),
                          SizedBox(
                            height: 25,
                            child: CustomSwitch(
                              activeColor: Colors.green,
                              value:context.watch<ProfileProvider>().profile.active ,
                              onChanged: (value) {
                                print("VALUE : $value");
                                context.read<ProfileProvider>().updateprofileStatus(value);
                                // setState(() {
                                //   _activeStatus = value;
                                // });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 40,
              ),
              Divider(),
              ListTile(
                onTap: ()=>Navigator.pushNamed(context, "/withdraw"),
                leading: Icon(Icons.money,color: Theme.of(context).accentColor,),
                title: Text("My Earnings"),
                subtitle: Row(children: [
                  Icon(Icons.wallet_giftcard_sharp,color: Theme.of(context).primaryColor,),
                  Text("Withdraw",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),)
                ],),
                trailing: context.watch<CustomerWalletProvider>().loading?Text("Loading...") : Text(
                  "${currency.symbol} ${context.watch<CustomerWalletProvider>().wallet.amount.toString()}",
                  style: TextStyle(),
                ),
              ),
              Divider(),
              ListTile(
                onTap: (){
                  launch("tel://${contact_support}");
                },
                leading: Icon(Icons.info,color: Theme.of(context).accentColor),
                title: Text("Issues? Contact Us"),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                   Provider.of<ProfileProvider>(context, listen: false).resetProfile();
                  Navigator.pushReplacementNamed(context, "/login");
                },
              ),
              //  Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
