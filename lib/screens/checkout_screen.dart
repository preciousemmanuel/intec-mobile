import 'package:flutter/material.dart';
import 'package:intechpro/providers/customer_wallet_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({ Key? key }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}



class _CheckoutScreenState extends State<CheckoutScreen> {



  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: WebView(
      initialUrl: 'https://checkout.paystack.com/7zu1ot06d0qn9h6',
      javascriptMode: JavascriptMode.unrestricted,
      userAgent: 'Flutter;Webview',
      navigationDelegate: (navigation){
      //Listen for callback URL
        if(navigation.url == "https://hello.pstk.xyz/callback"){
         // Provider.of<CustomerWalletProvider>(context,listen:false).validatePayment(location_hash);
         // verifyTransaction(reference);
          Navigator.of(context).pop(); //close webview
        }
        return NavigationDecision.navigate;
      },
    ),
  );
}
}