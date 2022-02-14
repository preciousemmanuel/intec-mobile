// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intechpro/model/request_model.dart';
import 'package:intechpro/model/service.dart';
import 'package:intl/intl.dart';

class RequestCard extends StatelessWidget {
  final Function onTap;
  final String type;
  final Request request;
  RequestCard({
    Key? key,
    required this.onTap,
    required this.request,
    this.type = "customer",
  }) : super(key: key);

  Widget _buildStatus() {
    if (request.requestStatus == 2) {
      return Container(
        decoration:  BoxDecoration(
          color: Color(0xffFFF3DB),
          borderRadius: BorderRadius.horizontal(
              right: Radius.circular(10), left: Radius.circular(10))),
        padding: EdgeInsets.all(5),
        child: Text("Yet to Pay", style: TextStyle(fontSize: 10,color: Color(0xffFDB72B))),
      );
    } else if (request.requestStatus == 3) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10), left: Radius.circular(10))),
        padding: EdgeInsets.all(5),
        child:
            Text("Active", style: TextStyle(fontSize: 10, color: Colors.white)),
      );
    }
     else if (request.requestStatus ==6) {
      return Container(
        decoration: BoxDecoration(
            color: Color(0xff5779b9),
            borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10), left: Radius.circular(10))),
        padding: EdgeInsets.all(5),
        child: Text("Complete; Not Paid ",
            style: TextStyle(fontSize: 10, color: Colors.white)),
      );
    } 
    
    
     else if (request.requestStatus > 3) {
      return Container(
        decoration: BoxDecoration(
            color: Color(0xff5779b9),
            borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10), left: Radius.circular(10))),
        padding: EdgeInsets.all(5),
        child: Text("Complete",
            style: TextStyle(fontSize: 10, color: Colors.white)),
      );
    } else if (request.requestStatus == 0) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10), left: Radius.circular(10))),
        padding: EdgeInsets.all(5),
        child: Text(
          "Cancelled",
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: Color(0xffFFF3DB),
          borderRadius: BorderRadius.horizontal(
              right: Radius.circular(10), left: Radius.circular(10))),
      padding: EdgeInsets.all(5),
      child: Text(
        "PENDING",
        style: TextStyle(color: Color(0xffFDB72B), fontSize: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ListTile(
          onTap: () {
            onTap();
          },
          leading: Icon(
            Icons.electric_rickshaw,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            request.service_name,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          subtitle: Text(
            "Location: ${request.request_address} .",
            style: TextStyle(fontSize: 10),
          ),
          trailing: Column(
            children: [
              Text(
                DateFormat("MMM d, yyyy").format(
                    DateTime.parse(request.createdTime ?? "2019-09-30")),
                style: TextStyle(fontSize: 11),
              ),
              SizedBox(
                height: 2,
              ),
              _buildStatus(),
            ],
          )),
    );
  }
}
