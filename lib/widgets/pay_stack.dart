import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';


class PaystackPayment  {
  final plugin = PaystackPlugin();
  int amount=0;
  String email="";

  PaystackPayment(this.amount,this.email){
    amount=amount;
    email=email;
    plugin.initialize(publicKey: dotenv.env["PAYSTACK_PUBLIC_API_KEY"]??"");
  }

  //used to generate a unique reference for payment
  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

   Future<String>_createAccessCode(_getReference) async {    
print("intitt#");
print(email);
print(amount);
 // skTest -> Secret key                        
 Map<String, String> headers = {                           
   'Content-Type': 'application/json',
   'Accept': 'application/json',
   'Authorization': 'Bearer ${dotenv.env["PAYSTACK_SECRET_API_KEY"]}'};
Map data = {"amount":  amount*100, "email":email, "reference": _getReference};
String payload = json.encode(data);                      
   http.Response response = await http.post( Uri.parse(
   'https://api.paystack.co/transaction/initialize'),
    headers: headers,
    body: payload);
    print("suc#");

    print(response.body);
final Map datax = jsonDecode(response.body);
String accessCode = datax['data']['access_code'];
return accessCode;
 }


 //async method to charge users card and return a response
  Future chargeCard(BuildContext context) async {
    
   String accesscode= await _createAccessCode(_getReference()) ;
    var charge = Charge()
      ..amount = amount *
          100 //the money should be in kobo hence the need to multiply the value by 100
      ..reference = _getReference()
       ..accessCode=accesscode
      ..putCustomField('custom_id',
          '846gey6w') //to pass extra parameters to be retrieved on the response from Paystack
      ..email = email;
      

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.selectable,
      charge: charge,
    );

    return response;

  }

}