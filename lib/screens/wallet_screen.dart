import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutterwave/core/flutterwave.dart';
// import 'package:flutterwave/flutterwave.dart';
// import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:intechpro/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intechpro/providers/customer_wallet_provider.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/screens/fund_wallet_bottomsheet.dart';
import 'package:intechpro/screens/webview_payment.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_paystack/flutter_paystack.dart';
//PayButton widget import below



class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController _amountTextController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final String _currency = FlutterwaveCurrency.NGN;
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();
  final plugin = PaystackPlugin();
  bool _isProcessingPayment=false;

  initState() {
    super.initState();
    plugin.initialize(publicKey: dotenv.env["PAYSTACK_PUBLIC_API_KEY"]??"");
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<CustomerWalletProvider>(context, listen: false)
          .fetch_wallet();
    });
  }

  //used to generate a unique reference for payment
  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }


  _handleWalletUpdate(BuildContext context) async {
    Map<String, dynamic> result = await context
        .read<CustomerWalletProvider>()
        .updateWallet(double.parse(_amountTextController.text));
        setState(() {
        _isProcessingPayment=false;
      });
    if (result["status"]) {
      
      ShowSnackBar(result["message"], true);
    } else {
      
      ShowSnackBar(result["message"], false);
    }
    Navigator.pop(context);
  }

  Future<String>_createAccessCode(_getReference) async {                        
 // skTest -> Secret key                        
 Map<String, String> headers = {                           
   'Content-Type': 'application/json',
   'Accept': 'application/json',
   'Authorization': 'Bearer ${dotenv.env["PAYSTACK_SECRET_API_KEY"]}'};
Map data = {"amount":  int.parse(_amountTextController.text) *100, "email": Provider.of<User>(context, listen: false).email??"", "reference": _getReference};
String payload = json.encode(data);                      
   http.Response response = await http.post( Uri.parse(
   'https://api.paystack.co/transaction/initialize'),
    headers: headers,
    body: payload);
final Map datax = jsonDecode(response.body);
String accessCode = datax['data']['access_code'];
return accessCode;
 }



  //async method to charge users card and return a response
  chargeCard(BuildContext context) async {
    
   String accesscode= await _createAccessCode(_getReference()) ;
    var charge = Charge()
      ..amount = int.parse(_amountTextController.text) *
          100 //the money should be in kobo hence the need to multiply the value by 100
      ..reference = _getReference()
       ..accessCode=accesscode
      ..putCustomField('custom_id',
          '846gey6w') //to pass extra parameters to be retrieved on the response from Paystack
      ..email = Provider.of<User>(context, listen: false).email??"";
      

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.selectable,
      charge: charge,
    );

print("dud#");
print(response);
print(response.message);
    //check if the response is true or not
    if (response.status == true) {
    //   //you can send some data from the response to an API or use webhook to record the payment on a database
    Map<dynamic,dynamic> _resp =await Provider.of<CustomerWalletProvider>(context,listen: false).validatePayment(response.reference);
    if (_resp["status"]) {
       _handleWalletUpdate(context);
    } else {
       ShowSnackBar(_resp["message"], false);
    }
     
    } else {
      setState(() {
        _isProcessingPayment=false;
      });
    //   print(response.message);
    //   //the payment wasn't successsful or the user cancelled the payment
       ShowSnackBar(response.message, false);
    }
  }

  // _handleCardPaymentInitialization(BuildContext context) async {
  //   final flutterwave = Flutterwave.forUIPayment(
  //       amount: _amountTextController.text,
  //       currency: _currency,
  //       context: this.context,
  //       publicKey: dotenv.env["FLUTTER_PUBLIC_API_KEY"]??"",
  //       encryptionKey: dotenv.env["ENCRYPTION_KEY"]??"",
  //       email: Provider.of<User>(context, listen: false).email??"",
  //       fullName: Provider.of<User>(context, listen: false).displayName??"",
  //       txRef: DateTime.now().toIso8601String(),
  //       narration: "Payment for IntecPro Wallet",
  //       isDebugMode: true,
  //       phoneNumber: Provider.of<ProfileProvider>(context, listen: false).profile.phone,
  //       acceptAccountPayment: true,
  //       acceptCardPayment: true,
  //       acceptUSSDPayment: true);
  //   try {
  //     final ChargeResponse response =
  //         await flutterwave.initializeForUiPayments();
  //     if (response == null) {
  //       //user didnt complete transaction
  //       ShowSnackBar(response.message??"", false);
  //       print(response);
  //     } else {
  //       final isSuccessful = checkPaymentIsSuccessful(response);
  //       if (isSuccessful) {
  //         // provide value to customer
  //         //successs call wallet provider
  //         _handleWalletUpdate(context);
  //       } else {
  //         // check message
  //         print(response.message);

  //         // check status
  //         print(response.status);

  //         // check processor error
  //         print(response.data!.processorResponse);
  //         ShowSnackBar(response.message??"", false);
  //       }
  //     }
  //   } catch (e) {}
  // }

  // bool checkPaymentIsSuccessful(final ChargeResponse response) {
  //   return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
  //       response.data!.currency == _currency;
  // }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      body: Container(
        // height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover)

              //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
              ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
       // color: Colors.white,
        child: SingleChildScrollView(
          child: context.watch<CustomerWalletProvider>().loading
              ? Center(
                  child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Loading Wallet...")
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width / 2.5,
                            top: 70,
                            child: Text(
                              "My Wallet",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: 80.0,
                              margin: EdgeInsets.only(top: 150),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(1, 3),
                                    )
                                  ]),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "₦ ${context.watch<CustomerWalletProvider>().wallet.amount.toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Wallet Balance",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:
                                              Theme.of(context).primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      
                        ],
                      ),
                    ),
                   
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet( 
                                context: context,
                                builder: (context) {
                                  return FundWalletBottomSheet();
                                
                                });
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle),
                                Text("Fund Wallet ")
                              ]),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Our Payment system is secured with the latest encryption algorithm from Paystack.  ",
                        style: TextStyle(
                            fontSize: 10, color: Theme.of(context).accentColor),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
