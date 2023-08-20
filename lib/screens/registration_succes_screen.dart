import 'package:flutter/material.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/screens/complete_artisan_profile_screen.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/screens/image_upload_screen.dart';
import 'package:provider/provider.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  final int userType;
  const RegistrationSuccessScreen({Key? key, required this.userType})
      : super(key: key);

  @override
  _RegistrationSuccessScreenState createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   setProfile();
    // });
  }

  setProfile() async {
    Map<String, dynamic> response =
        await context.read<ProfileProvider>().fetch_user();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Image.asset(
                "assets/images/checked.png",
                width: 170,
                height: 170,
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "Registration Success",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.black,
                    fontSize: 17),
              ),
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
              context.watch<ProfileProvider>().loading
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
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 50.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> response = await context
                              .read<ProfileProvider>()
                              .fetch_user();
                          if (response["status"]) {
                            if (widget.userType == 1) {
                              //customer
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            } else {
                              //artisans

                              

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => CompleteProfileScreen(
                                          userType: widget.userType,
                                        )),
                              );
                            }
                          } else {}
                        },
                        child: Text("Continue"),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
