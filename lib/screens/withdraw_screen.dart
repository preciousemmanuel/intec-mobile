import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intechpro/providers/customer_wallet_provider.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/screens/artisan/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _banks = [];
  bool _isBankLoading = false;
  bool _isFetchingAccountName = false;
  String _accountNumber = "";
  String _accountName = "";

  String _bankcode = "050";
  double _amount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getBanks();
  }

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    scaffoldkey.currentState!.showSnackBar(snackbar);
  }

  _getBanks() async {
    try {
      setState(() {
        _isBankLoading = true;
      });
      http.Response response = await http
          .get(Uri.parse("https://maylancer.org/api/nuban/banklist.php"));
      print("fmyBAnk##");
      print(response.body);
      var respMap = json.decode(response.body);
      print("myBAnk##");
      print(respMap);
      setState(() {
        List<Map<String, dynamic>> _bankRes = [];
        _isBankLoading = false;
        respMap.forEach((res) {
          print(res);
          _bankRes.add({"name": res["name"], "code": res["code"]});
        });
        _banks = _bankRes;
        print("added");

        print(_banks);
      });
    } catch (e) {
      print(e);
    }
  }

  _submitWithdrawal() async {
    if (_accountName == "") {
      ShowSnackBar("Please Enter a valid account number", false);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Map<String, dynamic> data = await context
        .read<CustomerWalletProvider>()
        .withdrawFromWallet(_amount, _bankcode, _accountNumber,Provider.of<ProfileProvider>(context,listen: false).profile.name);

    if (data["status"]) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("SUCCESS"),
              content: Text(data["message"]),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProfileScreen()),
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
      ShowSnackBar(data["message"], false);
    }
  }

  Widget _buildSubmitButton() {
    return context.watch<CustomerWalletProvider>().isSubmitting
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
                _submitWithdrawal();
                // if (_paymentMethodType == 1) {
                //   //handle card payment
                //   _handleCardPaymentInitialization(context);
                // } else if (_paymentMethodType == 2) {
                //   //handle wallet payment
                //   _handleWalletPayment();
                // }
              },
              child: Text("Continue "),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            ),
          );
  }

  getAccountByAccountNumber(val) async {
    if (_bankcode == "") {
      ///
      ShowSnackBar("Please select a Bank", false);
      return;
    }
    if (val.length > 1 && val.length < 10) {
      ShowSnackBar("Invalid account number", false);
      return;
    }
    try {
      setState(() {
        _accountName = "";
        _isFetchingAccountName = true;
      });
      print("bearea#");
      print(dotenv.env["FLUTTER_SECRET_API_KEY"]);
      http.Response response = await http.post(
          Uri.parse("https://api.flutterwave.com/v3/accounts/resolve"),
          body: json.encode({"account_number": val, "account_bank": _bankcode}),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${dotenv.env["FLUTTER_SECRET_API_KEY"]}"
          });
      setState(() {
        _isFetchingAccountName = false;
      });

      print(response.body);
      Map<String, dynamic> respData = json.decode(response.body);
      if (response.statusCode != 200) {
        ShowSnackBar(respData["message"], false);
        return;
      }

      if (respData["status"] == "success") {
        setState(() {
          _accountName = respData["data"]["account_name"];
        });
      } else {
        ShowSnackBar(respData["message"], false);
      }
    } catch (e) {
      print("errorT");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Withdrawal"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                    onChanged: (val) {
                      if (double.parse(val) >
                          Provider.of<CustomerWalletProvider>(context,
                                  listen: false)
                              .wallet
                              .amount) {
                        ShowSnackBar(
                            "You have entered amount higer than your wallet balance",
                            false);
                      }
                    },
                    keyboardType: TextInputType.number,
                    initialValue: context
                        .watch<CustomerWalletProvider>()
                        .wallet
                        .amount
                        .toString(),
                    // controller: _emailController,
                    validator: (value) {
                      if (value == "") {
                        return "Please Enter amou nt to withdraw";
                      }

                      if (double.parse(value!) >
                          Provider.of<CustomerWalletProvider>(context,
                                  listen: false)
                              .wallet
                              .amount) {
                        return "You have entered amount higer than your wallet balance";
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Amount to withdraw",
                        // filled: true,
                        labelStyle: TextStyle(color: Color(0xffA0A4A8)),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xffCACCCF),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff52575C))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffCACCCF)))),
                    onSaved: (value) => _amount = double.parse(value!)),
                SizedBox(
                  height: 10,
                ),
                DropdownButton(
                    hint: Text("Select your bank"),
                    value: _bankcode,
                    items: _banks.map((bank) {
                      return DropdownMenuItem(
                        child: Text(bank["name"]),
                        value: bank["code"],
                      );
                    }).toList(),
                    onChanged: (val) {
                      print("selected");
                      print(val);
                      setState(() {
                        _bankcode = val.toString();
                      });
                      getAccountByAccountNumber(_accountNumber);
                    }),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    maxLength: 10,
                    onChanged: (val) {
                      setState(() {
                        _accountName = "";
                        _accountNumber = val;
                      });
                      print(val);
                      print(val.length);
                      if (val.length == 10) {
                        getAccountByAccountNumber(val);

                        ///call an api to get account name and
                      }
                    },
                    keyboardType: TextInputType.number,
                    // controller: _emailController,
                    validator: (value) {
                      if (value == "") {
                        return "Please Enter Account Number";
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Account Number",
                        // filled: true,
                        labelStyle: TextStyle(color: Color(0xffA0A4A8)),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xffCACCCF),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff52575C))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffCACCCF)))),
                    onSaved: (value) => _accountNumber = value!),
                SizedBox(
                  height: 10,
                ),
                Text(_isFetchingAccountName
                    ? "Validating account number..."
                    : _accountName),
                SizedBox(height: 20),
                _buildSubmitButton()
              ],
            ),
          ),
        ),
      )),
    );
  }
}
