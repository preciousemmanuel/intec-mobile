// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/providers/customer_wallet_provider.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/screens/home_artisan_screen.dart';
import 'package:intechpro/widgets/pay_stack.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:flutter_paystack/flutter_paystack.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({ Key? key }) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();

  bool _isProcessingPayment=false;

  initState() {
    super.initState();
   
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
     
    });
  }



  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    scaffoldkey.currentState!.showSnackBar(snackbar);
  }


_handleSubscription(BuildContext context) async {
    Map<String, dynamic> result = await context
        .read<ProfileProvider>()
        .handleSubscription();
        setState(() {
        _isProcessingPayment=false;
      });
    if (result["status"]) {
      
      //ShowSnackBar("Subscription payment is successfull!", true);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("SUCCESS"),
              content: Text("Subscription payment is successful!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomeArtisanScreen()),
                        (Route<dynamic> route) => false);
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
      
      ShowSnackBar(result["message"], false);
    }
    Navigator.pop(context);
  }


  void _handleFundSubmit(BuildContext context) async {
    setState(() {
      _isProcessingPayment=true;
    });
    PaystackPayment paystack= PaystackPayment(2000,Provider.of<User>(context, listen: false).email??"");
   var response= await paystack.chargeCard(context);
   print("woringRT");
   print(response);

   if (response.status) {
_handleSubscription(context);
     //do your process successfull
   } else {
     setState(() {
       _isProcessingPayment=false;
     });
ShowSnackBar(response.message, false);
   }
  }

  

 



  

  Widget _buildSubmitButton(BuildContext context) {
    return _isProcessingPayment || context.watch<ProfileProvider>().getSubmitting
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor)),
          )
        : Container(
            height: 50.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _handleFundSubmit(context);
              },
              child: Text("Continue"),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            ),
          );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(title: Text("Suppliers Subscription"),
      backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: 
      Container(
          height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            
            children: [
              SizedBox(height: 30,),
              
Text("For you to continue to be listed on customers page , pay the yearly subscription fee of ${currency.symbol}2000.",style:TextStyle(fontWeight: FontWeight.bold)),

SizedBox(height: 40,),
_buildSubmitButton(context)

            ],
          ),
        ),
      ),),
    );
  }
}