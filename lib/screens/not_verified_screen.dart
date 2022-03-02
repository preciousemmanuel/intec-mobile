import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/screens/complete_artisan_profile_screen.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/model/currency.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';

class NotVerifyScreen extends StatefulWidget {
 
  const NotVerifyScreen({Key? key,})
      : super(key: key);

  @override
  _NotVerifyScreenState createState() =>
      _NotVerifyScreenState();
}

class _NotVerifyScreenState extends State<NotVerifyScreen> {

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   setProfile();
    // });
  }

  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child:  Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Image.asset(
                "assets/images/block.png",
                width: 170,
                height: 170,
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                context.watch<ProfileProvider>().profile.blocked? "Your account is Blocked":"Your account is not yet verified",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.black,
                    fontSize: 17),
              ),
              SizedBox(height: 30,),

              !context.watch<ProfileProvider>().profile.verified?  Text("You will be notified, when your account is verifed shortly."):Container(),
            //   SizedBox(
            //     height: 30,
            //   ),
            //  widget.userType==1? Text(
            //     "You have recieved ${currency.symbol}1000 into your walllet.",
            //     style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
            //   ):Container(),
              SizedBox(
                height: 70,
              ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ()async {
                    
  Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
                   
                  },
                  child: Text("OK"),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                ),
              ),

              SizedBox(height: 10,),
              TextButton(onPressed: (){
                 launch("tel://${contact_support}");
              }, child: Text("Contact Support")),
              SizedBox(height: 20,),
              TextButton(onPressed: ()async{
                    await FirebaseAuth.instance.signOut();
                   Provider.of<ProfileProvider>(context, listen: false).resetProfile();
                  Navigator.pushReplacementNamed(context, "/login");
              }, child: Text("Logout",style: TextStyle(color: Colors.red),))
            ],
          ),
        ),
      ),
    );
  }
}
