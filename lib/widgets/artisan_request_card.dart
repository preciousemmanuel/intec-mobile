import 'package:flutter/material.dart';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/providers/artisan_request_provider.dart';
import 'package:intechpro/screens/artisan/track_request_screen.dart';
import 'package:intechpro/widgets/address_detail.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class ArtisanRequestCard extends StatelessWidget {
  final request;
  final Function? onAcceptRequest;
  final Function? onClickIReach;
  const ArtisanRequestCard({Key? key, this.request, this.onAcceptRequest,this.onClickIReach})
      : super(key: key);

  Widget _buildCallButton(context) {
    if (request["requestStatus"] >= 3 && request["requestStatus"] < 4) {
      return TextButton(
        onPressed: () async{

          String url = "tel:${request["customer_phone"]}";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }

         // launch("tel://${request["customer_phone"]}");
        },
        child: Row(children: [
          Icon(
            Icons.call_rounded,
            color: Theme.of(context).accentColor,
            size: 20,
          ),
          Text(
            "Call Client",
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold),
          ),
        ]),
      );
    }

    return Container();
  }


  
  Widget _buildArrivedButton(context) {
    if (request["requestStatus"] >2 && (request["hasArrived"] == null || !request["hasArrived"]) ){
      return TextButton(
        onPressed: () {
         Provider.of<ArtisanRequestProvider>(context, listen: false).getSubmittingArrived?(){}:  onClickIReach!();
        },
        child: Row(children: [
          Icon(
            Icons.place_outlined,
            color: Colors.blueGrey,
            size: 20,
          ),
          Text(
             Provider.of<ArtisanRequestProvider>(context, listen: false).getSubmittingArrived?"Please Wait...": "Have you arrived?",
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          ),
        ]),
      );
    }

    return Container();
  }

  Widget _buildAcceptViewButton(context) {
    if (request["requestStatus"] == 1) {
      return TextButton(
        onPressed: () {
          onAcceptRequest!();
        },
        child: Row(children: [
          Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            "Accept",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ]),
      );
    } else {
      return TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TrackRequestScreen(
                request_id: request["order_id"],
                // userType: profile.userType,
              ),
            ),
          );
        },
        child: Row(children: [
          Icon(
            Icons.visibility,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            "View",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ]),
      );
    }
  }

  Widget _buildStatus(context) {
    if (request["requestStatus"] == 1) {
      return Container(
        padding: EdgeInsets.all(10),
        height: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Text(
          "Pending",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (request["requestStatus"] == 2) {
      return Container(
        padding: EdgeInsets.all(10),
        height: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Text(
          "Waiting Customer Confirmation",
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
      );
    } else if (request["requestStatus"] == 3) {
      return Container(
        padding: EdgeInsets.all(10),
        height: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Text(
          "Active",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (request["requestStatus"] == 4) {
      return Container(
        padding: EdgeInsets.all(10),
        height: 35,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Text(
          "Completed",
          style: TextStyle(color: Colors.white),
        ),
      );
    }else if (request["requestStatus"] == 6) {
      return Container(
        padding: EdgeInsets.all(10),
        height: 35,
        decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Text(
          "Denied Payment",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (request["requestStatus"] == 0) {
      return Container(
        padding: EdgeInsets.all(10),
        height: 35,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Text(
          "Cancelled",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(10),
      height: 35,
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Text(
        "Completed and Paid",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: request["userType"] == 3 ? 350 : 300,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.plumbing_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Column(
                children: [
                  Text(
                    DateFormat("MMM d, yyyy").format(
                        DateTime.parse(request["created_at"] ?? "2019-09-30")),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    request["customer_name"],
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
              _buildStatus(context)
            ],
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Row(
                children: [
                  Icon(Icons.electric_moped,
                      color: Theme.of(context).accentColor),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      request["service_name"],
                      style: TextStyle(color: Color(0xff52575C)),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    currency.symbol +(request["userType"]==3 && request["requestStatus"]<=3?request["amountForDistance"].toString() : request["amount"].toString()),
                    style: TextStyle(color: Color(0xff52575C)),
                  )
                ],
              ),
              SizedBox(
                height: 13,
              ),
              AddressDetail(
                userType: request["userType"],
                startAddress: request["address"],
                destinationAdress: request["address_destination"] ?? "",
              ),
            ]),
          ),
          Spacer(),
          Divider(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
            
              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAcceptViewButton(context),
                Row(
                  children: [
                    _buildArrivedButton(context),
                     _buildCallButton(context)
                  ],
                )
               
              ],
            ),
          )
        ],
      ),
    );
  }
}
