// import 'dart:js';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/model/product.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/model/task.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:intechpro/screens/request_service_screen.dart';
import 'package:intechpro/widgets/product_artisan_card.dart';
import 'package:intechpro/widgets/product_search_text.dart';
import 'package:intechpro/widgets/service_card.dart';
import 'package:intechpro/widgets/service_other_card.dart';
import 'package:intechpro/widgets/service_other_card_home.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupplierProductScreen extends StatefulWidget {
  Task service;
  
  SupplierProductScreen({required this.service});
  @override
  State<StatefulWidget> createState() {
    return _SupplierProductScreen();
  }
}

class _SupplierProductScreen extends State<SupplierProductScreen> {
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      
       fetch_products();
     
    });
  }

   Future<void> fetch_products() async {
 Provider.of<ProfileProvider>(context, listen: false)
            .fetch_products(
                 widget.service.uid);
   }

  void onhandleTap() async{
    print("sher@##");
  
      //supplier just take them to call supplier
      //go to products screen

 String url = "tel:${widget.service.phone}";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }

     
    
  }

  String url() {
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/+234${widget.service.phone}/?text=${Uri.parse('Hello!')}"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=+234${widget.service.phone}=${Uri.parse('Hello')}"; // new line
    }
  }

  void onhandleTapMsg()async {
    print("sher@##");
  
      //supplier just take them to call supplier
      //go to products screen
      if (await canLaunchUrl(Uri.parse(url()))) {
                      await launchUrl(Uri.parse(url()));
                    } else {
                      throw 'Could not launch $url()';
                    }

    
  }

  void onhandleTapMsgTwo()async {
    print("sher@##");
   // Android
    String uri = "sms:+234${widget.service.phone}?body=hello%20there";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      String uri = 'sms:+234${widget.service.phone}?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
    
  }

  


 handleOnChange(text){
    print("ryt##");
    print(text);
    Provider.of<ProfileProvider>(context, listen: false).getProductsSearcherd(text);
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
        
      backgroundColor: Color(0xffF0F0F0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.service.name+ " Products",
          style: TextStyle(color: Colors.black),
        ),
        
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/backgound.jpg"),
                  fit: BoxFit.cover)

              //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
              ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 22.0,
                ),
                Text(
                   "See products available in ${widget.service.name} shop. You can call for further details. ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                 ProductSearch(
                  onRefreshed:(){
                    fetch_products();
                  } ,
                  onChange: handleOnChange,
                ),
                context.watch<ProfileProvider>().loading
                    ? Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text("Loading ${widget.service.name} products...")
                          ],
                        ),
                      )
                    : Expanded(
                        // height: 400.0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ListView.builder(
                            // gridDelegate:
                            //     SliverGridDelegateWithFixedCrossAxisCount(
                            //         crossAxisCount: 3,
                            //         crossAxisSpacing: 10,
                            //         mainAxisSpacing: 10,
                            //         childAspectRatio: 8.0 / 9.0),
                            itemCount: context
                                .watch<ProfileProvider>()
                                .getProducts
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              Product product = context
                                  .watch<ProfileProvider>()
                                  .getProducts[index];
                              return  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ProductArtisanCard(onTap:()=> onhandleTap(), product: product),
                              );
                            },
                            // crossAxisCount: 3,
                          ),
                        ),
                      ), SizedBox(height: 80,)
              ],
            ),
          ),
        ),
      ),
       floatingActionButton: Column(
         mainAxisAlignment: MainAxisAlignment.end,
        children:[ FloatingActionButton(
            child: Icon(Icons.call),
            onPressed: () {
           onhandleTap();
             
            },
          ),
          SizedBox(height: 10,),
           FloatingActionButton(
            child: Icon(Icons.chat_rounded),
            onPressed: () {
           onhandleTapMsg();
             
            },
          ),

           SizedBox(height: 10,),
           FloatingActionButton(
            child: Icon(Icons.sms_rounded),
            onPressed: () {
           onhandleTapMsgTwo();
             
            },
          ),
        ],
      ),
    );
  }
}
