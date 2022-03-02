import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/model/wallet.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:intechpro/config.dart';

class CustomerWalletProvider with ChangeNotifier{

CollectionReference walletRef=FirebaseFirestore.instance.collection("wallet");
CollectionReference walletHistoryRef=FirebaseFirestore.instance.collection("wallet_history");

bool _is_loading=false;
bool _is_submiting=false;
  Wallet _wallet=Wallet(amount: 0.0);

String _payment_url="";


String get paymentUrl{
  return _payment_url;
}

Wallet get wallet{
  print("new#@");
  print(_wallet);
  return _wallet;
}

bool get loading{
  return _is_loading;
}
bool get isSubmitting{
  return _is_submiting;
}

  Future<Null> fetch_wallet() async {
try{
  var user =  FirebaseAuth.instance.currentUser;
_is_loading=true;
notifyListeners();

DocumentSnapshot walletDoc=await walletRef.doc(user!.uid).get();

print("wallet data");


_is_loading=false;
notifyListeners();
if (walletDoc.exists) {

  print(walletDoc.get("amount"));
final amount= walletDoc.get("amount");
print( amount.runtimeType);
print(amount.toDouble().runtimeType);
  _wallet=Wallet(amount: amount.toDouble());

} 
}on FirebaseException catch (e) {

  print(e);
  _is_loading=false;
  notifyListeners();
}

}

 Future<Map<dynamic,dynamic>> verifyPaymentServer(String reference) async{
    print("working");
   
    try {
Map<String, String> headers = {                           
   'Content-Type': 'application/json',
   'Accept': 'application/json',
   'Authorization': 'Bearer ${dotenv.env["PAYSTACK_SECRET_API_KEY"]}'};
http.Response response = await http.get(Uri.parse('https://api.paystack.co/transaction/verify/'+reference), headers: headers);
     final Map body = json.decode(response.body);
     print(body);
     //return body;
      if(body['data']['status'] == 'success'){
        return {"status":true,"message":"success"};
       //do something with the response. show success}
      }
      else{//show error prompt}
      return {"status":false,"message":"success"};
    } 
    
    }catch (e) {
      
      print(e);
      return {"status":false,"message":"failed"};
    }
  }


Future<Map<String,dynamic>> updateWallet(double amount)async{
  var user =  FirebaseAuth.instance.currentUser;
  print("typ#3");
print( amount.runtimeType);
  try {
    _is_submiting=true;
    notifyListeners();
    
    DocumentSnapshot walletData=await walletRef.doc(user!.uid).get();
print("wallet data");
double wallet=0;
if (walletData.exists) {
  wallet=walletData.get("amount").toDouble();
}

double totalAmount=amount+wallet;

    final walletDoc=await walletRef.doc(user.uid)
    .set({
      "amount":totalAmount
    });
    _wallet=Wallet(amount: totalAmount);
    _is_submiting=false;
    notifyListeners();
    return { "status":true,"message":"Wallet credited successfully"};
    
  } on FirebaseException catch (e) {
  print(e);
  _is_submiting=false;
  notifyListeners();
   return {"status": false, "message": e.message};
}
}


Future<Map<String,dynamic>> initiatePaystackTransfer(amount,recipient,reason)async{

  http.Response response = await http.post(Uri.parse("https://api.paystack.co/transfer"),body: json.encode({
  
  
   
    "amount": amount,
    "recipient": recipient,
    "currency": "NGN",
    
   
}),headers:{
    "Content-Type": "application/json",
    "Authorization":"Bearer ${dotenv.env["PAYSTACK_SECRET_API_KEY"]}"
  } );

  Map<String,dynamic> responseMap=json.decode(response.body);
  print("initTR##");
  print(responseMap);
  return responseMap;


}


Future<Map<String,dynamic>> withdrawFromWallet(double amount,String account_bank,account_number,String name)async{
amount=amount.toDouble();

if (amount<100) {
  return {"status":false,"message":"Withdrawable wallet amount must be at least 100 NGN. "};
}
try {
  var user =  FirebaseAuth.instance.currentUser;
   _is_submiting=true;
    notifyListeners();
   DocumentSnapshot walletData=await walletRef.doc(user!.uid).get();
print("wallet data");
double wallet=0;
if (walletData.exists) {
  wallet=walletData.get("amount").toDouble();
}
print(wallet);

if (amount>wallet) {
   _is_submiting=false;
    notifyListeners();
  return {"status":false,"message":"Amount to withdraw is more than wallet balance"};
}
print("reeqData#");
print({
  "type":"nuban",
  "name":name,
  "bank_code": account_bank,
    "account_number": account_number,
    
    
    "currency": "NGN",
   
    
});
http.Response response = await http.post(Uri.parse("https://api.paystack.co/transferrecipient"),body: json.encode({
  "type":"nuban",
  "name":name,
  "bank_code": account_bank,
    "account_number": account_number,
    "currency": "NGN",
}),headers:{
    "Content-Type": "application/json",
    "Authorization":"Bearer ${dotenv.env["PAYSTACK_SECRET_API_KEY"]}"
  } );

 _is_submiting=false;
    notifyListeners();
  print("codex");
  print(response.statusCode);
  print(response.body);
 Map<String,dynamic> resp=json.decode(response.body);
  if( response.statusCode!=201){
return {"status":false,"message":resp["message"]};
  }

 

  if (resp["status"]) {
Map<String,dynamic> transResp =await initiatePaystackTransfer(amount,resp["data"]["recipient_code"],"Withdrawal from my intecPRO wallet");
    //call transfer function
    if (transResp["status"]) {
         //update wallet
double totalAmount=wallet-amount;

    final walletDoc=await walletRef.doc(user.uid)
    .set({
      "amount":totalAmount
    });
    _wallet=Wallet(amount: totalAmount.toDouble());

    //add to withdrawal history

    await walletHistoryRef.doc(user.uid).collection("histories").add({
      "amount":amount,
      "created_at":Timestamp.now().toDate().toString()
    });

    return {"status":true,"message":"Transfer Queued Successfully"};
    } else {
    return {"status":false,"message":transResp["message"]};
    }

  } else {
    return {"status":false,"message":"Cannot process payment now"};
  }

} catch (e) {
  print("serverErro#");
  print(e);
   _is_submiting=false;
    notifyListeners();
  return {"status":false,"message":"Cannot process payment now"};
}

}



// Future<Map<String,dynamic>> withdrawFromWallet(double amount,String account_bank,account_number)async{
// amount=amount.toDouble();

// if (amount<1000) {
//   return {"status":false,"message":"Withdrawable wallet amount must be at least 1000 NGN. "};
// }
// try {
//    _is_submiting=true;
//     notifyListeners();
//    DocumentSnapshot walletData=await walletRef.doc(user!.uid).get();
// print("wallet data");
// double wallet=0;
// if (walletData.exists) {
//   wallet=walletData.get("amount").toDouble();
// }
// print(wallet);

// if (amount>wallet) {
//    _is_submiting=false;
//     notifyListeners();
//   return {"status":false,"message":"Amount to withdraw is more than wallet balance"};
// }
// http.Response response = await http.post(Uri.parse("https://api.flutterwave.com/v3/transfers"),body: json.encode({
//   "account_bank": account_bank,
//     "account_number": account_number,
//     "amount": amount,
//     "narration": "Withdrawal from my wallet",
//     "currency": "NGN",
//     "reference": Uuid().v4(),
//     "callback_url": "https://webhook.site/b3e505b0-fe02-430e-a538-22bbbce8ce0d",
//     "debit_currency": "NGN"
// }),headers:{
//     "Content-Type": "application/json",
//     "Authorization":"Bearer ${dotenv.env["FLUTTER_SECRET_API_KEY"]}"
//   } );

//  _is_submiting=false;
//     notifyListeners();
//   print("codex");
//   print(response.statusCode);
//   print(response.body);

//   if(response.statusCode!=200){
// return {"status":false,"message":"Cannot process payment now"};
//   }

//   Map<String,dynamic> resp=json.decode(response.body);

//   if (resp["status"]=="success") {
//     //update wallet
// double totalAmount=wallet-amount;

//     final walletDoc=await walletRef.doc(user!.uid)
//     .set({
//       "amount":totalAmount
//     });
//     _wallet=Wallet(amount: totalAmount.toDouble());

//     //add to withdrawal history

//     await walletHistoryRef.doc(user!.uid).collection("histories").add({
//       "amount":amount,
//       "created_at":Timestamp.now().toDate().toString()
//     });

//     return {"status":true,"message":"Transfer Queued Successfully"};

//   } else {
//     return {"status":false,"message":"Cannot process payment now"};

//   }






// } catch (e) {
//   print("serverErro#");
//   print(e);
//    _is_submiting=false;
//     notifyListeners();
//   return {"status":false,"message":"Cannot process payment now"};
// }

// }


Future<Map<String,dynamic>> initiatePayment(email,amount) async{
try {

   
  final http.Response response=await http.post(Uri.parse("${base_url}initiate/payment"),body:json.encode({
    "email":email,
    "amount":amount,
  
    // "location":location
  }) );
  print("response%%%###");
  print(response.body);
  print(response.statusCode);
  
if(response.statusCode!=200){
  return { "status":false,"message":json.decode(response.body)["message"]};
print("failed"); 
}
 final Map<String,dynamic> result = json.decode(response.body);
 print("result");
 print(result);

 if (result["status"]) {
   _payment_url=result["data"]["authorization_url"];
   return result;
 } 

 return { "status":false,"message":"Failed to make wallet payment"};


} catch (e) {

print("error payment");
print(e);
return{"status":false,"message":"Something went wrong"};
}

}




Future<Map<String,dynamic>> validatePayment(reference) async{
try {

   Map<String, String> headers = {                           
   'Content-Type': 'application/json',
   'Accept': 'application/json',
   'Authorization': 'Bearer ${dotenv.env["PAYSTACK_SECRET_API_KEY"]}'};
  final http.Response response=await http.get(Uri.parse("https://api.paystack.co/transaction/verify/$reference") ,headers: headers);
  print("response%%%###");
  print(response.body);
  print(response.statusCode);
  
if(response.statusCode!=200){
  return { "status":false,"message":json.decode(response.body)["message"]};
 
}
 final Map<String,dynamic> result = json.decode(response.body);
 print("result");
 print(result);

 if (result["data"]["status"]=="success") {
   return { "status":true,"message":""};
 }


 return { "status":false,"message":result["message"]};

} catch (e) {

print("error payment");
print(e);
return{"status":false,"message":"Something went wrong"};
}

}


}