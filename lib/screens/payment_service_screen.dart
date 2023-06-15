import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutterwave/flutterwave.dart';
import 'package:intechpro/config.dart';
import 'dart:async';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/model/task.dart';
import 'package:intechpro/providers/customer_wallet_provider.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/providers/service_payment_provider.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/screens/request_status_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intechpro/widgets/artisan_detail_section.dart';
import 'package:intechpro/widgets/pay_stack.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:sweetalert/sweetalert.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaymentServiceScreen extends StatefulWidget {
  LatLng? location;
  SubService? subservice;
  Service? parentService;
  Task? task;
  String? address;
  String? destinationAddress;
  String requestId;

  PaymentServiceScreen(
      {Key? key,
      this.location,
      this.subservice,
      this.parentService,
      this.address,
      this.task,
      required this.requestId,
      this.destinationAddress})
      : super(key: key);

  @override
  _PaymentServiceScreenState createState() => _PaymentServiceScreenState();
}

class _PaymentServiceScreenState extends State<PaymentServiceScreen> {
  int _paymentMethodType = 2;
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();
  List<int> _trips = [];
  int _selected_trip = 1;
  int _trip_cost = 0;
  final plugin = PaystackPlugin();
  late DatabaseReference _dbRef;
  late StreamSubscription<DatabaseEvent> _orderSubscription;
  FirebaseException? _error;
  bool initialized = false;
  bool _isProcessingPayment = false;
  var _request = null;
  String _selectedCancelOption = "";
  String _selectedIndexOption = "";

  void _handleRadioValueChanged(value) {
    setState(() => _paymentMethodType = value);
  }

  @override
  void initState() {
    super.initState();
    init();
    plugin.initialize(publicKey: dotenv.env["PAYSTACK_PUBLIC_API_KEY"] ?? "");
    _trip_cost = widget.subservice!.hasTask
        ? widget.task!.cost == 0
            ? widget.subservice!.cost
            : widget.task!.cost
        : widget.subservice!.cost;

    for (var i = 1; i <= 100; i++) {
      _trips.add(i);
    }
  }

  Future<void> init() async {
    setState(() {
      initialized = true;
    });
    _dbRef = FirebaseDatabase.instance.ref("queue/${widget.requestId}");
    // _dbRef.child("queue").child("${widget.request_id}");
    print("her###");
    print("queue/${widget.requestId}");
    print(_dbRef.get());
    _orderSubscription = _dbRef.onValue.listen((DatabaseEvent event) {
      print("new###db");
      print(event.snapshot.value);
      setState(() {
        initialized = false;
        _error = null;
        _request = event.snapshot.value;
        if (widget.parentService!.userType == 3) {
          _trip_cost = _request["amountForDistance"];
        }
        print("to##");
        print(_request);
      });
    }, onError: (Object o) {
      final error = o as FirebaseException;
      print(error);
      setState(() {
        _error = error;
      });
    });
  }

  @override
  void dispose() {
    _orderSubscription.cancel();
    super.dispose();
  }

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

  Future<String> _createAccessCode(_getReference) async {
    // skTest -> Secret key
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${dotenv.env["PAYSTACK_SECRET_API_KEY"]}'
    };
    Map data = {
      "amount": _trip_cost * 100,
      "email": Provider.of<User>(context, listen: false).email ?? "",
      "reference": _getReference
    };
    String payload = json.encode(data);
    http.Response response = await http.post(
        Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: headers,
        body: payload);
    final Map datax = jsonDecode(response.body);
    String accessCode = datax['data']['access_code'];
    return accessCode;
  }

  //async method to charge users card and return a response
  chargeCard(BuildContext context, amount, paymentMode, amountCash) async {
    setState(() {
      _isProcessingPayment = true;
    });

    PaystackPayment paystack = PaystackPayment(
        amount, Provider.of<User>(context, listen: false).email ?? "");
    var response = await paystack.chargeCard(context);

    //  String accesscode= await _createAccessCode(_getReference()) ;
    //   var charge = Charge()
    //     ..amount = int.parse(_trip_cost.toString()) *
    //         100 //the money should be in kobo hence the need to multiply the value by 100
    //     ..reference = _getReference()
    //      ..accessCode=accesscode
    //     ..putCustomField('custom_id',
    //         '846gey6w') //to pass extra parameters to be retrieved on the response from Paystack
    //     ..email = Provider.of<User>(context, listen: false).email??"";

    //   CheckoutResponse response = await plugin.checkout(
    //     context,
    //     method: CheckoutMethod.selectable,
    //     charge: charge,
    //   );

    print("dud#");
    print(response);
    print(response.message);
    //check if the response is true or not
    if (response.status == true) {
      //   //you can send some data from the response to an API or use webhook to record the payment on a database
      Map<dynamic, dynamic> _resp =
          await Provider.of<CustomerWalletProvider>(context, listen: false)
              .validatePayment(response.reference);
      if (_resp["status"]) {
        if (paymentMode == 1) {
          _handleWalletPayment(paymentMode, amount);
        } else {
          _handleWalletPayment(paymentMode, amountCash);
        }
      } else {
        ShowSnackBar(_resp["message"], false);
      }
    } else {
      setState(() {
        _isProcessingPayment = false;
      });
      //   print(response.message);
      //   //the payment wasn't successsful or the user cancelled the payment
      ShowSnackBar(response.message, false);
    }
  }

  _handleWalletPayment(paymentMode, amount) async {
    String taskname = widget.subservice!.hasTask
        ? widget.task!.cost == 0
            ? widget.subservice!.name + " Service; Request Assessment"
            : widget.task!.name
        : widget.subservice!.name;
    print("hre locatR##");
    print(widget.location!.latitude);
    Map<String, dynamic> response = await context
        .read<ServicePaymentProvider>()
        .handleWalletPayment(
            taskname,
            _selected_trip,
            widget.subservice!.uid,
            widget.parentService!.uid,
            widget.parentService!.userType,
            amount,
            widget.location!.latitude,
            widget.location!.longitude,
            widget.address,
            paymentMode,
            _request["order_id"]);
    setState(() {
      _isProcessingPayment = false;
    });

    if (response["status"]) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RequestStatusScreen(
            request_id: response["request_id"],
            newRequest: true,
          ),
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Wallet Info!"),
              content: Text(response["message"]),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/wallet");
                  },
                  child: Text(
                    'Fund Wallet',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            );
          });

      // ShowSnackBar(response["message"], false);

    }
  }

  // _handleCardPaymentInitialization(BuildContext context, amount) async {
  //   final flutterwave = Flutterwave.forUIPayment(
  //       amount: amount.toString(),
  //       currency: FlutterwaveCurrency.NGN,
  //       context: this.context,
  //       publicKey: dotenv.env["FLUTTER_PUBLIC_API_KEY"] ?? "",
  //       encryptionKey: dotenv.env["ENCRYPTION_KEY"] ?? "",
  //       email: Provider.of<User>(context, listen: false).email ?? "",
  //       fullName: Provider.of<User>(context, listen: false).displayName ?? "",
  //       txRef: DateTime.now().toIso8601String(),
  //       narration: "Payment for ${widget.subservice!.name} service",
  //       isDebugMode: false,
  //       phoneNumber:
  //           Provider.of<ProfileProvider>(context, listen: false).profile.phone,
  //       acceptAccountPayment: true,
  //       acceptCardPayment: true,
  //       acceptUSSDPayment: true);
  //   final response = await flutterwave.initializeForUiPayments();
  //   if (response != null) {
  //     print(response);
  //     _handleWalletPayment(1, amount);
  //   } else {
  //     ShowSnackBar(response.message ?? "", false);
  //   }
  // }

  Widget _buildSubmitButton() {
    final amount = widget.subservice!.hasTask
        ? widget.task!.cost == 0
            ? widget.subservice!.cost.toString()
            : widget.task!.cost.toString()
        : widget.subservice!.cost.toString();
    return context.watch<ServicePaymentProvider>().isSubmitting ||
            _isProcessingPayment
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
                setState(() {
                  _isProcessingPayment = true;
                });
                if (_paymentMethodType == 1) {
                  //handle card payment

                  chargeCard(context, _trip_cost, 1, 0);
                } else if (_paymentMethodType == 2) {
                  //handle wallet payment
                  _handleWalletPayment(2, _trip_cost);
                } else if (_paymentMethodType == 3) {
                  //pay with cash
                  var amountToPay = 20 / 100 * _trip_cost;
                  var amountCash = _trip_cost - amountToPay;

                  showDialog(
                      context: context,
                      builder: (contextx) {
                        return AlertDialog(
                          title: Text("Info"),
                          content: Text(
                              "You will pay ${currency.symbol}${amountToPay.toString()} online, and ${currency.symbol}${amountCash.toString()} cash after work completion."),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(contextx);
                                  setState(() {
                                    _isProcessingPayment = false;
                                  });
                                },
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                )),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(contextx);
                                chargeCard(context, amountToPay.toInt(), 3,
                                    amountCash.toInt());
                              },
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          ],
                        );
                      });

                  //pay 20% online and pay the rest to the user
                }
              },
              child: Text("Pay ${currency.symbol}  ${_trip_cost}  "),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            ),
          );
  }

  void _handleCancelRadioValueChanged(value) {
    print(value);
    setState(() => _selectedCancelOption = value);
  }

  Widget _buildCancelTile(title, index, setState) {
    print("on##");
    print(title);
    return ListTile(
        onTap: () {
          print("benny#");
          print(title);
          setState(() {
            _selectedIndexOption = index;
            _selectedCancelOption = title;
          });
        },
        title: Text(
          title,
        ),
        leading: Radio(
            value: title,
            groupValue: _selectedCancelOption,
            onChanged: _handleCancelRadioValueChanged));
  }

  Widget _buildCancelButton() {
    return Column(
      children:[
        SizedBox(height: 60,),
       Container(
        height: 45.0,
        width: MediaQuery.of(context).size.width/2,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
        //   borderRadius: BorderRadius.circular(10)
        // ),
        // width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setSheetState) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Why do you want to cancel request?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _buildCancelTile(
                              "No Artisan/Supplier/Truck found! I have waited a very long time",
                              "1",
                              setSheetState),
                          Divider(),
                          _buildCancelTile("I dont want to continue request", "2",
                              setSheetState),
                          Divider(),
                          _buildCancelTile(
                              "Request was a mistake", "3", setSheetState),
    
                          Divider(),
                          // CancelTile(title: "", selected: ""),
                          context.watch<ServicePaymentProvider>().isSubmitting
                              ? Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)),
                                )
                              : Container(
                                  height: 40.0,
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                                  //   borderRadius: BorderRadius.circular(10)
                                  // ),
                                  // width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_selectedCancelOption != "") {
                                        
                                        context
                                            .read<ServicePaymentProvider>()
                                            .cancelRequest(_request["order_id"],
                                                _selectedCancelOption, "customer")
                                            .then((value) {
                                          if (value["status"]) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text("Message"),
                                                    content: Text("Request Cancelled successfully"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          Navigator.of(context)
                                                              .pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          HomeScreen()),
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false);
                                                        },
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                });
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text("Message"),
                                                    content:
                                                        Text(value["message"]),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                });
                                          }
                                        });
                                      } else {}
                                    },
                                    child: Text(
                                      "Continue ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        shape: StadiumBorder(),
                                        side: BorderSide(
                                            color: Theme.of(context).accentColor),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        primary: Theme.of(context).accentColor),
                                  ),
                                )
                        ],
                      ),
                    );
                  });
                });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(
              Icons.more_sharp,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "More",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ]),
          style: OutlinedButton.styleFrom(
              shape: StadiumBorder(),
              side: BorderSide(color: Theme.of(context).accentColor),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              primary: Colors.white),
        ),
      ),
   
       ] );
  }

  Widget _buildExpiredSection(){
    return Column(
      children:[
        Text("Request is expired . Please reinitiate a new request",style: TextStyle(color: Colors.red),),
        SizedBox(height: 20,),
        TextButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("Go Back"))
      ]
    );
  }

  Widget _buildExpirationInfo(){
    return Row(
      children: [
        Icon(Icons.info_sharp,color: Colors.red,),
        SizedBox(width: 10,),
       Expanded(child: const Text("Unprocessed Payment cancels after 20mins.",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),))
      ]
    );
      
  }

  Widget _buildShowPaymentSection() {
    return Column(
      children: [
        widget.parentService!.userType == 3
            ? Container(
                height: 120.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Number of Trips",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton(
                              value: _selected_trip,
                              items: _trips.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e.toString()),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selected_trip =
                                      int.tryParse(val.toString()) ?? 0;
                                  _trip_cost =
                                      (widget.parentService!.userType == 3
                                              ? _request["amountForDistance"]
                                              : widget.subservice!.cost)! *
                                          int.parse(val.toString());
                                });
                              }),
                          Text(currency.symbol + _trip_cost.toString()),
                        ],
                      ),
                    ],
                  ),
                ))
            : Container(),
        SizedBox(
          height: 30,
        ),

        _buildExpirationInfo(),
         SizedBox(
          height: 20,
        ),

        Container(
            height: 450.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Service Fee",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        "₦  ${_trip_cost} ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 1,
                          groupValue: _paymentMethodType,
                          onChanged: _handleRadioValueChanged),
                      Text(
                        "Pay with Card",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/master.png",
                        width: 68,
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "assets/images/paypal.png",
                        width: 68,
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "assets/images/visa.png",
                        width: 68,
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 2,
                          groupValue: _paymentMethodType,
                          onChanged: _handleRadioValueChanged),
                      Text(
                        "Pay with Wallet",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/wallet.png",
                        width: 68,
                        height: 40.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 3,
                          groupValue: _paymentMethodType,
                          onChanged: _handleRadioValueChanged),
                      Text(
                        "Pay with Cash",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/money.png",
                        width: 68,
                        height: 40.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildSubmitButton()
                ],
              ),
            ))
      ],
    );
  }

  Widget _buildAdress() {
    if (widget.parentService!.userType == 3) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Pickup Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.home,
              color: Theme.of(context).accentColor,
            ),
            Expanded(child: Text(widget.address ?? "")),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text("Destination Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.place,
              color: Theme.of(context).accentColor,
            ),
            Expanded(child: Text(widget.destinationAddress ?? "")),
          ],
        )
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Location",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.location_city,
            color: Theme.of(context).accentColor,
          ),
          Expanded(child: Text(widget.address ?? "")),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Pay for Service"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("assets/images/background-front.jpg"),
                fit: BoxFit.cover)

            //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
            ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _request == null
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                        Text(
                          "Please wait...",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        )
                      ],
                    ),
                  )
                : Column(children: [
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        height:
                            widget.parentService!.userType == 3 ? 250.0 : 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Service Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.plumbing_rounded,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Text(widget.subservice!.hasTask
                                      ? widget.task!.name
                                      : widget.subservice!.name),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              _buildAdress()
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 15,
                    ),

                  _request["requestStatus"] == 1?   Container(
 padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ]),
                    child: Row(
                      children: [
                        Text("Service Cost:",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(currency.symbol+_trip_cost.toString())
                      ],
                    ),
                    ):Container(),
                     SizedBox(
                      height: 20,
                    ),
                    _request["requestStatus"] == 1
                        ? Center(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  _request["userType"] == 2
                                      ? "Searching for the best Artisan for you. Please wait..."
                                      : _request["userType"] == 3
                                          ? "Searching for the best Truck Driver for you. Please wait..."
                                          : "Searching for the best Supplier for you. Please wait...",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                )
                              ],
                            ),
                          )
                        : ArtisanDetailSection(
                            request: _request,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    _request["requestStatus"] == 1
                        ? _buildCancelButton()
                        : Container(),

                        _request["requestStatus"]==2?_buildShowPaymentSection():Container(),

                        _request["requestStatus"]==0?_buildExpiredSection():Container()



                  ]),
          ),
        ),
      ),
    );
  }
}
