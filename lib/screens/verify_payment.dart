

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/screens/wallet_screen.dart';
import 'package:intechpro/screens/webview_payment.dart';
import 'package:provider/provider.dart';

import '../providers/customer_wallet_provider.dart';

class VerifyPayment extends StatefulWidget {
  final String reference;
  const VerifyPayment({Key? key,required this.reference}) : super(key: key);

  @override
  State<VerifyPayment> createState() => _VerifyPaymentState();
}

class _VerifyPaymentState extends State<VerifyPayment> {


@override
  initState(){
  super.initState();
verify();
  
}

verify()async{
  var res=await Provider.of<CustomerWalletProvider>(context, listen: false).verifyPayment(widget.reference);
  if (res==true) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>  WalletScreen()));
  } else {
    ShowSnackBar("Failed to verify",false);
  }
}
  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Container(
        color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(children: [

            SizedBox(height: 50,) , 
              Container(
                child: Center(
                  child: Image.asset(
                    "assets/images/Loader.gif",
                    height: 70.0,
                    width: 70.0,
                  ),
                ),
              ),
              SizedBox(height: 10,)
    ,
    
    Text("Verifying Payment... Please wait")          ],),
          ),
      ),
    )   ;                      
  }
}