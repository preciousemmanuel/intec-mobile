

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/screens/webview_payment.dart';
import 'package:provider/provider.dart';

import '../providers/customer_wallet_provider.dart';

class FundWalletBottomSheet extends StatefulWidget {
  const FundWalletBottomSheet({Key? key}) : super(key: key);

  @override
  State<FundWalletBottomSheet> createState() => _FundWalletBottomSheetState();
}

class _FundWalletBottomSheetState extends State<FundWalletBottomSheet> {
TextEditingController _amountTextController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final String _currency = FlutterwaveCurrency.NGN;
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();
bool _isProcessingPayment=false;
  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _handleFundSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
        _isProcessingPayment=true;
      });
try {
     var res= await Provider.of<CustomerWalletProvider>(context, listen: false).initiateWebPayment( Provider.of<User>(context, listen: false).email??"",int.parse(_amountTextController.text) *100);
   setState(() {
        _isProcessingPayment=false;
      });
      print("posiushdres,${res}");
   if (res["status"]==true) {
        Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>  WebViewPaymentScreen(paymentLink: res["data"]["authorization_url"],)));
   } else {
     ShowSnackBar(res["message"], false);
   }
} catch (e) {
   setState(() {
        _isProcessingPayment=false;
      });
   ShowSnackBar(e.toString(), false);
}
  
    //chargeCard(context);
  }


 Widget _buildSubmitButton(BuildContext context) {
    return _isProcessingPayment
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
                  primary: Theme.of(context).accentColor),
            ),
          );
  }


  @override
  Widget build(BuildContext context) {
    return   Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            "Fund Your wallet",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: _amountTextController,
                                            validator: (value) {
                                              if (value == "") {
                                                return "Please Enter Amount ";
                                              }
                                              if (value == 0 || value == "0") {
                                                return "Please enter valid amount";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Enter amount to Fund",
                                                // filled: true,
                                                labelStyle: TextStyle(
                                                    color: Color(0xffA0A4A8)),
                                                prefixIcon: Icon(
                                                  Icons.money_sharp,
                                                  color: Color(0xffCACCCF),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xff52575C))),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xffCACCCF)))),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          _buildSubmitButton(context)
                                        ],
                                      ),
                                    ),
                                  );
                                
  }
}